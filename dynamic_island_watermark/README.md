# dynamic_island_watermark

<p align="center">
  <a href="https://pub.dev/packages/dynamic_island_watermark"><img src="https://img.shields.io/pub/v/dynamic_island_watermark.svg" alt="pub.dev"></a>
  <a href="https://github.com/ueman#sponsor-me"><img src="https://img.shields.io/github/sponsors/ueman" alt="Sponsoring"></a>
  <a href="https://pub.dev/packages/dynamic_island_watermark/score"><img src="https://img.shields.io/pub/likes/dynamic_island_watermark" alt="likes"></a>
  <a href="https://pub.dev/packages/dynamic_island_watermark/score"><img src="https://img.shields.io/pub/points/dynamic_island_watermark" alt="pub points"></a>
</p>

A Flutter package that adds a subtle watermark behind the Dynamic Island on supported iPhone models. Perfect for growth-hacking or adding helpful information in screenshots.

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

<video controls>
  <source src="video.mov" type="video/mp4">
</video>

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
