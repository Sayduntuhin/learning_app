import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'views/splash/splash_view.dart';

void main() {
  runApp(const FluentioApp());
}

class FluentioApp extends StatelessWidget {
  const FluentioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      fontSizeResolver: (fontSize, instance) {
        return fontSize * (instance.scaleText > 1.15 ? 1.15 : instance.scaleText);
      },
      builder: (context, child) {
        return MaterialApp(
          title: 'Fluentio',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: child,
        );
      },
      child: const SplashView(),
    );
  }
}
