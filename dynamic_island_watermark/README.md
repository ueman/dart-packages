# dynamic_island_watermark

<p align="center">
  <a href="https://pub.dev/packages/dynamic_island_watermark"><img src="https://img.shields.io/pub/v/dynamic_island_watermark.svg" alt="pub.dev"></a>
  <a href="https://github.com/ueman#sponsor-me"><img src="https://img.shields.io/github/sponsors/ueman" alt="Sponsoring"></a>
  <a href="https://pub.dev/packages/dynamic_island_watermark/score"><img src="https://img.shields.io/pub/likes/dynamic_island_watermark" alt="likes"></a>
  <a href="https://pub.dev/packages/dynamic_island_watermark/score"><img src="https://img.shields.io/pub/points/dynamic_island_watermark" alt="pub points"></a>
</p>

A Flutter package that adds a subtle watermark on screenshots behind the Dynamic Island on supported iPhone models. Perfect for growth-hacking or adding helpful information in screenshots. This package does nothing on devices without a dynamic island.

## Motivation

The Dynamic Island on iPhone models like the Pro series is a unique, interactive UI feature. Adding a watermark behind the Dynamic Island helps you:

* **Growth hack**: A/B test new features or promotional content without permanently modifying your UI.
* **Debugging**: Include version information in screenshot that get sent to you, without making it otherwise user visible

## Installation

Add `dynamic_island_watermark` as a dependency in your `pubspec.yaml`:

```yaml
dependencies:
  dynamic_island_watermark: ^1.0.0
```

Then fetch the package:

```bash
flutter pub get
```

## Usage

Wrap your app with the `DynamicIslandWatermark` widget:

```dart
import 'package:dynamic_island_watermark/dynamic_island_watermark.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    DynamicIslandWatermark(
      watermark: Watermark(),
      child: const MyApp(),
    ),
  );
}
```

### Parameters

* `watermark` (Widget): The widget displayed as the watermark.
* `child` (Widget): Your app.

## Demo

<p align="center">
  <img src="https://raw.githubusercontent.com/ueman/dart-packages/1beada19c1e8b20cf8df47346d6fc1c16923f867/dynamic_island_watermark/media/example.gif" width="250" alt="Example GIF">
</p>

# Recommendations and tips

### ✅ Do's

- Only display your brand or application logo—otherwise you risk store-submission issues.

### ❌ Don’ts

- Avoid placing extraneous visuals (especially ads). Only display your brand or application logo—otherwise you risk store-submission issues.
- Never embed important or sensitive information in the watermark widget. Assume users won’t even notice it.
- Don’t add tap callbacks to widgets positioned under hardware barriers. Users won’t be able to interact with them.
- Don’t use the watermark if your app’s top app bar is already crowded with elements. It will make the UI look overloaded.

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to open an issue or submit a pull request.

## 📣 About the author

- [![Twitter Follow](https://img.shields.io/twitter/follow/ue_man?style=social)](https://twitter.com/ue_man)
- [![GitHub followers](https://img.shields.io/github/followers/ueman?style=social)](https://github.com/ueman)
- [![Bluesky Follow](https://img.shields.io/badge/Follow%20on%20Bluesky-08f)](https://bsky.app/profile/uekoetter.dev)
- [![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=flat&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/ueman)
