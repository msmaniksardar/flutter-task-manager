import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/ui/utility/assets_path.dart';

class BackgroundScreen extends StatelessWidget {
  const BackgroundScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.sizeOf(context).width;

    return Stack(
      children: [
        Positioned(
            child: SvgPicture.asset(
          AssetsPath.backgroundSvgImage,
          width: width,
          fit: BoxFit.cover,
        )),
        SafeArea(child: child)
      ],
    );
  }
}
