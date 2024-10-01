# DIO image provider

[![pub package](https://img.shields.io/pub/v/dio_image_provider.svg)](https://pub.dev/packages/dio_image_provider) [![likes](https://img.shields.io/pub/likes/dio_image_provider)](https://pub.dev/packages/dio_image_provider/score) [![popularity](https://img.shields.io/pub/popularity/dio_image_provider)](https://pub.dev/packages/dio_image_provider/score) [![pub points](https://img.shields.io/pub/points/dio_image_provider)](https://pub.dev/packages/dio_image_provider/score)

This is an alternative to [`Image.network()`](https://api.flutter.dev/flutter/widgets/Image/Image.network.html) which makes use of the [`dio`](https://pub.dev/packages/dio) package.

## Motivation

By re-using dio as network client for images over the network, you can easily re-use existing authentication code. This also makes it easier to do performance monitoring when used with Sentry, Datadog or similar.

## Usage

```dart
Image(
  image: DioImage(Uri.parse('https://http.cat/200')),
)
```

Optionally, you can supply your own `Dio` client.

```dart
// Either by setting it globally
DioImage.defaultDio = Dio();

// or by supplying it via constructor
Image(
  image: DioImage(
    Uri.parse('https://http.cat/200'),
    dio: Dio(),
  ),
)
```

If you use [`http`](https://pub.dev/packages/http) instead of [dio](https://pub.dev/packages/dio), try [`http_image_provider`](https://pub.dev/packages/http_image_provider)

## 📣 About the author

- [![Twitter Follow](https://img.shields.io/twitter/follow/ue_man?style=social)](https://twitter.com/ue_man)
- [![GitHub followers](https://img.shields.io/github/followers/ueman?style=social)](https://github.com/ueman)
