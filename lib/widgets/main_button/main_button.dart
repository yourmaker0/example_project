import 'package:example_project/styles/color_palette.dart';
import 'package:example_project/styles/text_styles.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String title;

  final Color color;

  final Color textColor;

  final bool isEnabled;

  final VoidCallback onTap;

  final double buttonHeight;

  final double? width;

  final double fontSize;

  final double borderRadius;

  final Color? disabledTextColor;

  final Color? disabledBackgroundColor;

  const MainButton({
    Key? key,
    required this.title,
    this.color = ColorPalette.main,
    this.isEnabled = true,
    this.textColor = ColorPalette.white,
    required this.onTap,
    this.buttonHeight = 48,
    this.width,
    this.fontSize = 16,
    this.borderRadius = 12,
    this.disabledTextColor,
    this.disabledBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: buttonHeight,
          width: width ?? MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ButtonStyle(
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              backgroundColor: MaterialStateProperty.all<Color>(
                !isEnabled && disabledBackgroundColor != null
                    ? disabledBackgroundColor!
                    : color,
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide.none,
                ),
              ),
            ),
            onPressed: isEnabled ? onTap : null,
            child: Center(
              child: Text(
                title,
                style: ProjectTextStyles.ui_16Semi.copyWith(
                  color: !isEnabled && disabledBackgroundColor != null
                      ? disabledTextColor
                      : textColor,
                  height: 1.5,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
        if (!isEnabled && disabledBackgroundColor == null)
          Positioned.fill(
            child: Container(
              height: buttonHeight,
              width: width ?? MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: ColorPalette.white.withOpacity(0.55),
              ),
            ),
          ),
      ],
    );
  }
}
