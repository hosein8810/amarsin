import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Brightness? _brightness;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    _brightness = WidgetsBinding.instance?.window.platformBrightness;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {
        _brightness = WidgetsBinding.instance?.window.platformBrightness;
      });
    }

    super.didChangePlatformBrightness();
  }

  CupertinoThemeData get _lightTheme => CupertinoThemeData(
        brightness: Brightness.light, /* light theme settings */
      );

  CupertinoThemeData get _darkTheme => CupertinoThemeData(
        brightness: Brightness.dark, /* dark theme settings */
      );

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        title: 'Demo App',
        theme: _brightness == Brightness.dark ? _darkTheme : _lightTheme,
        home: Scaffold());
  }
}
