import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DynamicIslandWatermark extends StatelessWidget {
  /// Typically this is your Material app
  final Widget child;

  /// The watermark
  final Widget watermark;

  /// The text direction for this subtree.
  final TextDirection? textDirection;

  const DynamicIslandWatermark({
    super.key,
    required this.watermark,
    required this.child,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return child;
    }
    if (!Platform.isIOS) {
      return child;
    }

    final actualTextDirection =
        textDirection ??
        Directionality.maybeOf(context) ??
        _getDeviceDefault(context);

    return Stack(
      textDirection: actualTextDirection,
      children: [
        child,
        _IslandWatermark(
          textDirection: actualTextDirection,
          watermark: watermark,
        ),
      ],
    );
  }

  TextDirection _getDeviceDefault(BuildContext context) {
    final locale =
        View.maybeOf(context)?.platformDispatcher.locale ??
        PlatformDispatcher.instance.locale;
    const rtlLanguages = ['ar', 'fa', 'he', 'ps', 'sd', 'ur'];
    return rtlLanguages.contains(locale.languageCode.toLowerCase())
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
}

class _IslandWatermark extends StatefulWidget {
  /// The text direction for this subtree.
  final TextDirection textDirection;

  final Widget watermark;

  const _IslandWatermark({
    required this.textDirection,
    required this.watermark,
  });

  @override
  State<_IslandWatermark> createState() => _IslandWatermarkState();
}

class _IslandWatermarkState extends State<_IslandWatermark> {
  String? modelName;

  @override
  void initState() {
    super.initState();
    unawaited(_loadiPhoneModel());
  }

  Future<void> _loadiPhoneModel() async {
    final name = (await DeviceInfoPlugin().iosInfo).modelName;
    if (!mounted) return;
    setState(() {
      modelName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (modelName == null) return SizedBox.shrink();

    final config = _getConfig(modelName!);

    if (config == null) return SizedBox.shrink();

    // Only show the watermark when the device is in portrait orientation.
    // In landscape (or any other) orientations, the Dynamic Island placement
    // does not make sense and can cause visual artifacts.
    final isPortrait = _isPortrait();

    if (!isPortrait) return SizedBox.shrink();

    return Positioned(
      top: config.top,
      height: config.height,
      left: config.horizontal,
      right: config.horizontal,
      // TODO(ueman): Use ClipRSuperellipse eventually?
      child: ClipRRect(
        //clipBehavior: Clip.none, // Can be enabled/disbled for better testing
        borderRadius: BorderRadius.all(Radius.circular(config.borderRadius)),
        child: Directionality(
          textDirection: widget.textDirection,
          child: widget.watermark,
        ),
      ),
    );
  }

  _DynamicIslandConfig? _getConfig(String modelName) {
    return switch (modelName) {
      'iPhone 16 Pro' => _DynamicIslandConfig.iPhone16Pro,
      'iPhone 16 Pro Max' => _DynamicIslandConfig.iPhone16ProMax,
      'iPhone 16' => _DynamicIslandConfig.iPhone16,
      'iPhone 16 Plus' => _DynamicIslandConfig.iPhone16Plus,
      'iPhone 15 Pro' => _DynamicIslandConfig.iPhone15Pro,
      'iPhone 15 Pro Max' => _DynamicIslandConfig.iPhone15ProMax,
      'iPhone 15' => _DynamicIslandConfig.iPhone15,
      'iPhone 15 Plus' => _DynamicIslandConfig.iPhone15Plus,
      'iPhone 14 Pro' => _DynamicIslandConfig.iPhone15Pro,
      'iPhone 14 Pro Max' => _DynamicIslandConfig.iPhone15ProMax,
      _ => null,
    };
  }

  bool _isPortrait() {
    final orientation = MediaQuery.maybeOrientationOf(context);
    if (orientation != null) {
      return orientation == Orientation.portrait;
    }

    final view = View.maybeOf(context);
    if (view != null) {
      final size = view.physicalSize;
      return size.height >= size.width;
    }

    // Default to not showing when orientation cannot be determined.
    return false;
  }
}

enum _DynamicIslandConfig {
  iPhone16(top: 12, height: 36, horizontal: 134, borderRadius: 20),
  iPhone16Plus(top: 12, height: 36, horizontal: 153, borderRadius: 20),
  iPhone16Pro(top: 14, height: 36, horizontal: 139, borderRadius: 25),
  iPhone16ProMax(top: 14, height: 36, horizontal: 158, borderRadius: 25),
  iPhone15(top: 12, height: 35, horizontal: 135, borderRadius: 20),
  iPhone15Plus(top: 12, height: 35, horizontal: 153, borderRadius: 20),
  // Also used for iPhone 14 Pro
  iPhone15Pro(top: 12, height: 35, horizontal: 135, borderRadius: 25),
  // Also used for iPhone 14 Pro Max
  iPhone15ProMax(top: 12, height: 35, horizontal: 153, borderRadius: 25);

  final double top;
  final double height;
  final double horizontal;
  final double borderRadius;

  const _DynamicIslandConfig({
    required this.top,
    required this.height,
    required this.horizontal,
    required this.borderRadius,
  });
}
