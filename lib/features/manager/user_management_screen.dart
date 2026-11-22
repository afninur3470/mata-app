import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'Budi Santoso',
      'email': 'budi.santoso@telkomsel.co.id',
      'role': 'Engineer',
      'isActive': true,
    },
    {
      'id': '2',
      'name': 'Ahmad Rizky',
      'email': 'ahmad.rizky@telkomsel.co.id',
      'role': 'Engineer',
      'isActive': true,
    },
    {
      'id': '3',
      'name': 'Dewi Sartika',
      'email': 'dewi.sartika@telkomsel.co.id',
      'role': 'Engineer',
      'isActive': true,
    },
    {
      'id': '4',
      'name': 'Eko Prasetyo',
      'email': 'eko.prasetyo@telkomsel.co.id',
      'role': 'Manager',
      'isActive': true,
    },
    {
      'id': '5',
      'name': 'Siti Aminah',
      'email': 'siti.aminah@telkomsel.co.id',
      'role': 'Admin Support',
      'isActive': false,
    },
  ];

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRole = 'Engineer';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(
          'Manajemen User',
          style: AppTypography.headingH6.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB31216), Color(0xFFED1C24)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildInfoBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daftar Member NBAD',
                        style: AppTypography.headingH6.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showAddMemberModal,
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Member Baru'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFED1C24),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildUserDataTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0369A1).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0369A1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF0369A1)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Akun dikelola secara internal oleh Departemen NBAD Telkomsel.',
              style: AppTypography.bodySmall.copyWith(
                color: const Color(0xFF0369A1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDataTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Nama')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Aksi')),
          ],
          rows: _users.map((user) {
            return DataRow(
              cells: [
                DataCell(Text(user['name'] as String)),
                DataCell(Text(user['email'] as String)),
                DataCell(_buildRoleChip(user['role'] as String)),
                DataCell(_buildStatusChip(user['isActive'] as bool)),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      _showUserOptions(user);
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    Color color;
    switch (role) {
      case 'Manager':
        color = const Color(0xFFB31216);
        break;
      case 'Admin Support':
        color = const Color(0xFF0284C7);
        break;
      case 'Engineer':
      default:
        color = const Color(0xFFF97316);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        role,
        style: AppTypography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: isActive ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'Aktif' : 'Non-Aktif',
            style: AppTypography.bodySmall.copyWith(
              color: isActive ? Colors.green : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMemberModal() {
    _nameController.clear();
    _emailController.clear();
    _selectedRole = 'Engineer';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Tambah Member Baru'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      hintText: 'Masukkan nama lengkap',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Telkomsel',
                      hintText: 'nama@telkomsel.co.id',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Role',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...['Engineer', 'Admin Support', 'Manager'].map((role) {
                    return RadioListTile<String>(
                      title: Text(role),
                      value: role,
                      groupValue: _selectedRole,
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedRole = value!;
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Email undangan akan dikirim ke alamat email yang terdaftar.',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: _isSubmitting ? null : () => _submitInvite(setDialogState),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFED1C24),
                  foregroundColor: Colors.white,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Kirim Undangan'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submitInvite(StateSetter setDialogState) async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan email harus diisi')),
      );
      return;
    }

    if (!email.endsWith('@telkomsel.co.id')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email harus menggunakan domain @telkomsel.co.id')),
      );
      return;
    }

    setDialogState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: Call Supabase Edge Function 'invite-user'
      // Or use supabase.auth.admin.inviteUserByEmail()
      // For now, simulate the invite
      
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Undangan berhasil dikirim ke $email'),
            backgroundColor: Colors.green,
          ),
        );

        // Add user to local list for demo
        setState(() {
          _users.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'name': name,
            'email': email,
            'role': _selectedRole,
            'isActive': false, // Pending activation
          });
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim undangan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setDialogState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showUserOptions(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit User'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement edit
                },
              ),
              ListTile(
                leading: Icon(
                  user['isActive'] ? Icons.block : Icons.check_circle,
                  color: user['isActive'] ? Colors.red : Colors.green,
                ),
                title: Text(user['isActive'] ? 'Non-Aktifkan' : 'Aktifkan'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    user['isActive'] = !(user['isActive'] as bool);
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Hapus User', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteUser(user);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus User'),
        content: Text('Apakah Anda yakin ingin menghapus ${user['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _users.removeWhere((u) => u['id'] == user['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User berhasil dihapus')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
