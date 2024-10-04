import 'package:http_image_provider/http_image_provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Image(
            image: HttpImageProvider(Uri.parse('https://http.cat/200')),
          ),
        ),
      ),
    );
  }
}
