<p align="center">
  <img src="https://raw.githubusercontent.com/ueman/splash/master/img/splash.png" max-height="100" alt="Splash" />
</p>

<p align="center">
  <a href="https://pub.dartlang.org/packages/splash"><img src="https://img.shields.io/pub/v/splash.svg" alt="pub.dev"></a>
  <a href="https://pub.dev/packages/splash/score"><img src="https://img.shields.io/pub/likes/splash" alt="likes"></a>
  <a href="https://pub.dev/packages/splash/score"><img src="https://img.shields.io/pub/popularity/splash" alt="popularity"></a>
  <a href="https://pub.dev/packages/splash/score"><img src="https://img.shields.io/pub/points/splash" alt="pub points"></a>
</p>

<p align="center">
  <a href="https://twitter.com/ue_man"><img src="https://img.shields.io/twitter/follow/ue_man?style=social" alt="Twitter Follow"></a>
  <a href="https://github.com/ueman"><img src="https://img.shields.io/github/followers/ueman?style=social" alt="GitHub followers"></a>
  <a href="https://bsky.app/profile/uekoetter.dev"><img src="https://img.shields.io/badge/Follow%20on%20Bluesky-08f" alt="TBluesky Follow"></a>
  <a href="https://github.com/sponsors/ueman"><img src="https://img.shields.io/badge/Sponsor-30363D?style=flat&logo=GitHub-Sponsors&logoColor=#EA4AAA" alt="GitHub Sponsor"></a>
</p>

---

💰 Using this library in a commercial product? Consider [becoming a sponsor](https://github.com/ueman#sponsor-me).

This package contains a few alternatives for [InkSplash.splashFactory](https://api.flutter.dev/flutter/material/InkSplash/splashFactory-constant.html)
and [InkRipple.splashFactory](https://api.flutter.dev/flutter/material/InkRipple/splashFactory-constant.html). In other words this are custom button pressed effects.

## List of available alternatives

| Example                                           | Usage  |
|-                                                  |-      |
| ![Wave Splash](https://raw.githubusercontent.com/ueman/splash/master/img/wave_splash.gif "Wave Splash") | `WaveSplash.splashFactory`, `WaveSplash.customSplashFactory(strokeWidth: 30, blurStrength: 5)` |
| ![Path Splash](https://raw.githubusercontent.com/ueman/splash/master/img/path_splash.gif "Path Splash") | `PathSplash.splashFactory(path)`, `PathSplash.splashFactory(path, paint: paint, clip: false)` |
| ![Line Splash](https://raw.githubusercontent.com/ueman/splash/master/img/line_splash.gif "Line Splash") | `LineSplash.splashFactory`, `LineSplash.customSplashFactory(paint: paint)` | 
| ![No Splash](https://raw.githubusercontent.com/ueman/splash/master/img/no_splash.gif "No Splash")       | `NoSplash.splashFactory` | 

You can find an extensive example [here](https://github.com/ueman/splash/blob/master/example/lib/main.dart).
It shows simple usages and some more advances examples.

## How do I use them?

```dart
import 'package:splash/splash.dart';

final splashFactory = ...

MaterialApp(
  theme: Theme(
    splashFactory: splashFactory,
  ),
  home: Scaffold(), 
);
```
```dart
import 'package:splash/splash.dart';

final splashFactory = ...

OutlinedButton(
  child: const Text('OutlineButton'),
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    splashFactory: splashFactory,
  ),
);
```


# New features and ideas

I would really appreciate pull request with new splash factories or good looking examples in the example app. You can do it [here](https://github.com/ueman/splash).

## Author

- Jonas Uekötter [GitHub](https://github.com/ueman) [Twitter](https://twitter.com/ue_man)
