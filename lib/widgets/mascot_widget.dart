import 'package:flutter/material.dart';

class MascotWidget extends StatefulWidget {
  final double size;
  final bool animate;

  const MascotWidget({
    super.key,
    this.size = 48,
    this.animate = true,
  });

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _animationController = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      )..repeat(reverse: true);

      _scaleAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    if (widget.animate) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) {
      return _buildMascot();
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: _buildMascot(),
    );
  }

  Widget _buildMascot() {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: _MascotPainter(),
        size: Size(widget.size, widget.size),
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 100;

    // Robot body
    final bodyPaint = Paint()
      ..color = const Color(0xFFED1C24)
      ..style = PaintingStyle.fill;

    final bodyRect = Rect.fromCenter(
      center: center,
      width: 60 * scale,
      height: 70 * scale,
    );
    final bodyRRect = RRect.fromRectAndRadius(bodyRect, Radius.circular(15 * scale));
    canvas.drawRRect(bodyRRect, bodyPaint);

    // Robot head
    final headPaint = Paint()
      ..color = const Color(0xFFB31216)
      ..style = PaintingStyle.fill;

    final headRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - 35 * scale),
      width: 50 * scale,
      height: 45 * scale,
    );
    final headRRect = RRect.fromRectAndRadius(headRect, Radius.circular(12 * scale));
    canvas.drawRRect(headRRect, headPaint);

    // Visor (cyan glowing)
    final visorPaint = Paint()
      ..color = const Color(0xFF00BCD4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
      ..style = PaintingStyle.fill;

    final visorRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - 40 * scale),
      width: 30 * scale,
      height: 12 * scale,
    );
    final visorRRect = RRect.fromRectAndRadius(visorRect, Radius.circular(6 * scale));
    canvas.drawRRect(visorRRect, visorPaint);

    // Eyes
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final leftEyeCenter = Offset(center.dx - 8 * scale, center.dy - 32 * scale);
    final rightEyeCenter = Offset(center.dx + 8 * scale, center.dy - 32 * scale);

    canvas.drawCircle(leftEyeCenter, 5 * scale, eyePaint);
    canvas.drawCircle(rightEyeCenter, 5 * scale, eyePaint);

    // Antenna
    final antennaPaint = Paint()
      ..color = const Color(0xFFB31216)
      ..style = PaintingStyle.fill
      ..strokeWidth = 4 * scale;

    final antennaStart = Offset(center.dx, center.dy - 57 * scale);
    final antennaEnd = Offset(center.dx, center.dy - 70 * scale);
    canvas.drawLine(antennaStart, antennaEnd, antennaPaint);

    // Antenna bulb (cyan)
    final bulbPaint = Paint()
      ..color = const Color(0xFF00BCD4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(antennaEnd, 6 * scale, bulbPaint);

    // Arms
    final armPaint = Paint()
      ..color = const Color(0xFFED1C24)
      ..style = PaintingStyle.fill;

    final leftArmRect = Rect.fromCenter(
      center: Offset(center.dx - 35 * scale, center.dy + 10 * scale),
      width: 12 * scale,
      height: 30 * scale,
    );
    final leftArmRRect = RRect.fromRectAndRadius(leftArmRect, Radius.circular(6 * scale));
    canvas.drawRRect(leftArmRRect, armPaint);

    final rightArmRect = Rect.fromCenter(
      center: Offset(center.dx + 35 * scale, center.dy + 10 * scale),
      width: 12 * scale,
      height: 30 * scale,
    );
    final rightArmRRect = RRect.fromRectAndRadius(rightArmRect, Radius.circular(6 * scale));
    canvas.drawRRect(rightArmRRect, armPaint);

    // Chest light
    final chestPaint = Paint()
      ..color = const Color(0xFF00BCD4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2)
      ..style = PaintingStyle.fill;

    final chestCenter = Offset(center.dx, center.dy + 5 * scale);
    canvas.drawCircle(chestCenter, 8 * scale, chestPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
