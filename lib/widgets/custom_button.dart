// ignore_for_file: must_be_immutable

import 'package:calculator/widgets/bouncing.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  String buttonText;
  bool isLightMode;

  CustomButton({required this.buttonText, required this.isLightMode});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;
    var size = screenHeight / screenWidth;
    return BouncingWidget(
      onPress: () {},
      child: Padding(
        padding: EdgeInsets.all(size * 5),
        child: AnimatedContainer(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 100),
          child: Text(
            widget.buttonText,
            style: TextStyle(
                fontSize: size * 25,
                color: widget.isLightMode ? Colors.black : Colors.white,
                fontWeight: FontWeight.w300),
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.isLightMode ? Colors.grey.shade600 : Colors.black,
                offset: Offset(4, 4),
                blurRadius: 15,
                spreadRadius: 1,
              ),
              BoxShadow(
                color:
                    widget.isLightMode ? Colors.white60 : Colors.grey.shade800,
                offset: Offset(-2, -2),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
            gradient: widget.isLightMode
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade200,
                      Colors.grey.shade300,
                      Colors.grey.shade400,
                      Colors.grey.shade500,
                    ],
                    stops: [0.1, 0.3, 0.8, 1],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black38,
                      Colors.black45,
                      Colors.black54,
                      Colors.black87,
                    ],
                    stops: [0.1, 0.3, 0.8, 1],
                  ),
          ),
        ),
      ),
    );
  }
}
