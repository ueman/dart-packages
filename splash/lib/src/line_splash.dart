import 'package:flutter/material.dart';

const Duration _kProgressDuration = Duration(milliseconds: 225);

class _LineSplashFactory extends InteractiveInkFeatureFactory {
  const _LineSplashFactory(this.paint);

  final Paint? paint;

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return LineSplash(
      controller: controller,
      referenceBox: referenceBox,
      color: color,
      onRemoved: onRemoved,
      newPaint: paint,
    );
  }
}

class LineSplash extends InteractiveInkFeature {
  LineSplash({
    required MaterialInkController controller,
    required super.referenceBox,
    required Color color,
    super.onRemoved,
    Paint? newPaint,
  }) : super(
          controller: controller,
          color: color,
        ) {
    // Start animation as soon as possible
    _progressController = AnimationController(
      duration: _kProgressDuration,
      vsync: controller.vsync,
    )
      ..addListener(controller.markNeedsPaint)
      ..forward();

    _progressAnimation = _progressController.drive(Tween<double>(
      begin: 0,
      end: 1,
    ));

    // Add this InkFeature to the controller so that this gets drawn
    controller.addInkFeature(this);

    if (newPaint == null) {
      paint = Paint()
        ..color = color
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
    } else {
      paint = newPaint;
    }
  }

  static const InteractiveInkFeatureFactory splashFactory =
      _LineSplashFactory(null);

  static InteractiveInkFeatureFactory customSplashFactory(Paint paint) =>
      _LineSplashFactory(paint);

  late Animation<double> _progressAnimation;
  late AnimationController _progressController;
  late Paint paint;

  /// Called when the button press is confirmed.
  @override
  void confirm() => _progressController.reverse();

  /// Called when the button press is canceled.
  @override
  void cancel() => _progressController.reverse();

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    // TODO(any): add support for rtl

    final progress = _progressAnimation.value;
    if (progress == 0) {
      return;
    }
    final rect = referenceBox.size;

    const double startX = 0;
    final startY = rect.height / 2;
    final endX = rect.width * progress;
    var path = Path();
    path.moveTo(startX, startY);
    path.lineTo(endX, startY);

    // the matrix is a 2D translation, so this never returns null
    final originOffset = MatrixUtils.getAsTranslation(transform)!;
    path = path.shift(originOffset);
    canvas.drawPath(path, paint);
  }
}
