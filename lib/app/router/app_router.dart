import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/engineer/home/engineer_home_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/manager/war_room_screen.dart';
import '../../features/ai_copilot/ai_copilot_screen.dart';
import '../../features/engineer/task_detail/task_detail_screen.dart';
import '../../features/shared/unauthorized_screen.dart';
import '../../features/shells/manager_shell.dart';
import '../../features/shells/admin_support_shell.dart';
import '../../features/shells/engineer_shell.dart';
import '../../features/dispatcher/dispatcher_console_screen.dart';

class AppRouter {
  static String getUserRole() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return 'guest';
    
    final userMetadata = user.userMetadata;
    if (userMetadata == null) return 'guest';
    final role = userMetadata['user_role'] as String?;
    return role ?? 'guest';
  }

  static bool isAuthorized(String requiredRole) {
    final userRole = getUserRole();
    return userRole == requiredRole;
  }

  static GoRouter router() {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final user = Supabase.instance.client.auth.currentUser;
        final userRole = getUserRole();
        
        // If not logged in, redirect to login
        if (user == null) {
          if (state.matchedLocation == '/login') return null;
          return '/login';
        }
        
        // If logged in and on login page, redirect based on role
        if (state.matchedLocation == '/login') {
          switch (userRole) {
            case 'manager':
              return '/manager/war-room';
            case 'admin_support':
              return '/admin/dashboard';
            case 'engineer':
              return '/engineer/home';
            default:
              return '/login';
          }
        }
        
        // Check role-based access
        final path = state.matchedLocation;
        
        // Manager routes
        if (path.startsWith('/manager') && userRole != 'manager') {
          return '/unauthorized';
        }
        
        // Admin/Dispatcher routes
        if (path.startsWith('/admin') && userRole != 'admin_support') {
          return '/unauthorized';
        }
        
        // Engineer routes
        if (path.startsWith('/engineer') && userRole != 'engineer') {
          return '/unauthorized';
        }
        
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/unauthorized',
          name: 'unauthorized',
          builder: (context, state) => const UnauthorizedScreen(),
        ),
        // Manager routes
        ShellRoute(
          builder: (context, state, child) => ManagerShell(child: child),
          routes: [
            GoRoute(
              path: '/manager/war-room',
              name: 'manager_war_room',
              builder: (context, state) => const WarRoomScreen(),
            ),
            GoRoute(
              path: '/manager/living-map',
              name: 'manager_living_map',
              builder: (context, state) => const Placeholder(),
            ),
            GoRoute(
              path: '/manager/escalations',
              name: 'manager_escalations',
              builder: (context, state) => const Placeholder(),
            ),
            GoRoute(
              path: '/manager/analytics',
              name: 'manager_analytics',
              builder: (context, state) => const Placeholder(),
            ),
            GoRoute(
              path: '/manager/users',
              name: 'manager_users',
              builder: (context, state) => const Placeholder(),
            ),
          ],
        ),
        // Admin/Dispatcher routes
        ShellRoute(
          builder: (context, state, child) => AdminSupportShell(child: child),
          routes: [
            GoRoute(
              path: '/admin/dashboard',
              name: 'admin_dashboard',
              builder: (context, state) => const DispatcherConsoleScreen(),
            ),
            GoRoute(
              path: '/admin/repository',
              name: 'admin_repository',
              builder: (context, state) => const Placeholder(),
            ),
            GoRoute(
              path: '/admin/tracking',
              name: 'admin_tracking',
              builder: (context, state) => const Placeholder(),
            ),
            GoRoute(
              path: '/admin/baut',
              name: 'admin_baut',
              builder: (context, state) => const Placeholder(),
            ),
          ],
        ),
        // Engineer routes
        ShellRoute(
          builder: (context, state, child) => EngineerShell(child: child),
          routes: [
            GoRoute(
              path: '/engineer/home',
              name: 'engineer_home',
              builder: (context, state) => const EngineerHomeScreen(),
            ),
            GoRoute(
              path: '/engineer/tasks',
              name: 'engineer_tasks',
              builder: (context, state) => const Placeholder(),
            ),
            GoRoute(
              path: '/engineer/journal',
              name: 'engineer_journal',
              builder: (context, state) => const Placeholder(),
            ),
            GoRoute(
              path: '/engineer/inbox',
              name: 'engineer_inbox',
              builder: (context, state) => const Placeholder(),
            ),
            GoRoute(
              path: '/engineer/profile',
              name: 'engineer_profile',
              builder: (context, state) => const Placeholder(),
            ),
            GoRoute(
              path: '/task/:id',
              name: 'task_detail',
              builder: (context, state) {
                final taskId = state.pathParameters['id']!;
                return TaskDetailScreen(taskId: taskId);
              },
            ),
          ],
        ),
        // Shared routes
        GoRoute(
          path: '/ai-copilot',
          name: 'ai_copilot',
          builder: (context, state) => const AICopilotScreen(),
        ),
      ],
    );
  }
}

