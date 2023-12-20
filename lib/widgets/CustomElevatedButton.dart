import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final Color? primary;
  final ShapeBorder? shape;

  const CustomElevatedButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.elevation,
    this.padding,
    this.primary,
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        padding: padding,
        primary: primary,
        // shape: shape,
      ),
    );
  }
}