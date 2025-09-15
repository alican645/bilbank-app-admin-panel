
import 'dart:ui';

import 'package:flutter/material.dart';

class CustomGradientScaffold extends StatelessWidget {
  const CustomGradientScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.gradientColors,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       extendBodyBehindAppBar: true,        // 👈 önemli
      backgroundColor: Colors.transparent, // 👈 arka planı şeffaf tu
      appBar: appBar,
      extendBody: true, // NavBar altına taşan efektler için
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

