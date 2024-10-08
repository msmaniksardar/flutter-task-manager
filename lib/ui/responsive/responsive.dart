import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget Mobile;

  final Widget Tablet;
  final Widget Desktop;

  ResponsiveLayout(
      {required this.Mobile, required this.Tablet, required this.Desktop});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 576) {
        return Mobile;
      } else if (constraints.maxWidth < 768) {
        return Tablet;
      } else {
        return Desktop;
      }
    });
  }
}
