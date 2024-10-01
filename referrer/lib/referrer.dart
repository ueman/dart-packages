import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Referrer {
  @visibleForTesting
  final methodChannel = const MethodChannel('referrer');

  /// On iOS this uses [NSUserActivity.referrerUrl](https://developer.apple.com/documentation/foundation/nsuseractivity/2875762-referrerurl).
  /// On Android this uses [Intent#EXTRA_REFERRER](https://developer.android.com/reference/android/content/Intent#EXTRA_REFERRER).
  /// OS version support is as per documentation above.
  /// There's no backwards compatibility.
  Future<ReferrerInfo?> getReferrer() async {
    if (kIsWeb) {
      return null;
    }
    final isiOSorAndroid = Platform.isAndroid || Platform.isIOS;
    if (!isiOSorAndroid) {
      return null;
    }
    try {
      final referrer = await methodChannel
          .invokeMethod<Map<dynamic, dynamic>>('getReferrer');
      if (referrer == null) {
        return null;
      }

      referrer.removeWhere((key, value) => value == null);

      if (referrer.isEmpty) {
        return null;
      }

      return ReferrerInfo.fromMap(referrer);
    } on PlatformException catch (e, s) {
      final exception = ReferrerPlatformException.fromPlatformException(e);
      Error.throwWithStackTrace(exception, s);
    }
  }

  /// On iOS this uses [NSUserActivity.referrerUrl](https://developer.apple.com/documentation/foundation/nsuseractivity/2875762-referrerurl).
  /// On Android this uses [Intent#EXTRA_REFERRER](https://developer.android.com/reference/android/content/Intent#EXTRA_REFERRER).
  /// OS version support is as per documentation above.
  /// There's no backwards compatibility.
  Future<Uri?> getReferrerUrl() async {
    return (await getReferrer())?.referrer;
  }
}

// Custom exception to indicate this exception comes from this referrer package.
// Keep the PlatformException as superclass, to keep support of monitoring tools
// for PlatformExceptions.
class ReferrerPlatformException extends PlatformException {
  ReferrerPlatformException({
    required super.code,
    super.message,
    super.details,
    super.stacktrace,
  });

  factory ReferrerPlatformException.fromPlatformException(
    PlatformException platformException,
  ) {
    return ReferrerPlatformException(
      code: platformException.code,
      message: platformException.message,
      details: platformException.details,
      stacktrace: platformException.stacktrace,
    );
  }
}

class ReferrerInfo {
  ReferrerInfo({
    required this.referrer,
    required this.referrerName,
    required this.referrerBrowswer,
  });

  static ReferrerInfo? fromMap(Map<dynamic, dynamic> map) {
    if (map.isEmpty) {
      return null;
    }

    final referrer = (map['referrer'] as String?)?.trim();
    // Parsing it to URI is safe, since it's always coming in as a URI on the
    // native side. It can't be anything else than a URI.
    final referrerUri =
        referrer != null && referrer.isNotEmpty ? Uri.parse(referrer) : null;

    final referrerName = map['referrerName'] as String?;
    final referrerBrowswer = map['browserName'] as String?;

    return ReferrerInfo(
      referrer: referrerUri,
      referrerName: referrerName,
      referrerBrowswer: referrerBrowswer,
    );
  }

  /// Available on iOS and Android
  final Uri? referrer;

  /// Available on Android
  final String? referrerName;

  /// Available on Android
  final String? referrerBrowswer;
}
