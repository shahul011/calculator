import 'package:calculator/listitems.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'custom_button.dart';

class CalculatorBody extends StatefulWidget {
  @override
  State<CalculatorBody> createState() => _CalculatorBodyState();
}

class _CalculatorBodyState extends State<CalculatorBody> {
  TextEditingController questionController = TextEditingController();
  final _scrollController = ScrollController();
  String question = '';
  String answer = '';
  int count = 0;
  bool _isLightMode = true;

  _mode() {
    setState(() {
      _isLightMode = !_isLightMode;
    });
  }

  evaluate(String variable) {
    setState(() {
      if (variable == 'AC') {
        question = '';
        answer = '';
        questionController.text = '';
        count = 0;
      } else if (variable == '⌫') {
        question = question.substring(0, question.length - 1);
        questionController.text = question;
      } else if (variable == '( )') {
        if (count == 0) {
          question = question + '(';
          questionController.text = question;

          count++;
        } else if (question.substring(question.length - 1, question.length) ==
                '(' ||
            question.substring(question.length - 1, question.length) ==
                '[0-9]') {
          question = question + '(';
          questionController.text = question;

          count++;
        } else {
          if (count >= 0) {
            question = question + ')';
            questionController.text = question;

            count--;
          }
        }
      } else if (variable == '=') {
        for (int i = count; i >= 0; i--) {
          if (count != 0) {
            question = question + ')';
            count--;
          }
        }

        question = question
            .replaceAll('÷', '/')
            .replaceAll('x', '*')
            .replaceAll(RegExp(r"^0+(?!$)"), '')
            .replaceAll(')(', ')*(');

        List<String> temp = question.split("").toList();
        for (int i = 0; i < temp.length; i++) {
          if (temp[i].contains(')') && i < temp.length - 1) {
            if (temp[i + 1].contains(RegExp(r'^[0-9]+$'))) {
              temp.insert(i + 1, '*');
            }
          }
        }
        for (int i = 1; i < temp.length; i++) {
          if (temp[i].contains('(') &&
              temp[i - 1].contains(RegExp(r'^[0-9]+$'))) {
            temp.insert(i, '*');
            i++;
          }
        }

        question = temp.toString();
        question = question
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll(',', '')
            .replaceAll(' ', '');
        questionController.text = question;

        try {
          Parser p = Parser();
          Expression exp = p.parse(question);
          ContextModel cm = ContextModel();
          double temp1 =
              double.parse(exp.evaluate(EvaluationType.REAL, cm).toString());
          answer = temp1.toStringAsFixed(3).replaceFirst(RegExp(r'\.?0*$'), '');
        } catch (e) {
          answer = 'Syntax error';
          question = '';
          questionController.text = question;
        }
      } else {
        question = question + variable;
        answer = '';
        questionController.text = question;
      }
    });
    Future.delayed(Duration(milliseconds: 30)).then((value) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      _scrollController.jumpTo(maxScroll);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;
    var size = screenHeight / screenWidth;
    return Stack(
      children: [
        Container(
          color: _isLightMode ? Colors.grey[400] : Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: screenHeight / 3,
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 40),
                      TextField(
                          controller: questionController,
                          scrollController: _scrollController,
                          readOnly: true,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: _isLightMode
                              ? TextStyle(
                                  fontSize: size * 50,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)
                              : TextStyle(
                                  fontSize: size * 50,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white)),
                      SizedBox(
                        height: 20,
                      ),
                      answer == 'Syntax error'
                          ? Text(
                              answer,
                              style: TextStyle(
                                  fontSize: size * 30,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red.shade400),
                            )
                          : _isLightMode
                              ? Text(
                                  answer,
                                  style: TextStyle(
                                    fontSize: size * 30,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.end,
                                )
                              : Text(
                                  answer,
                                  style: TextStyle(
                                    fontSize: size * 30,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.white,
                                  ),
                                ),
                      // SizedBox(height: 20)
                    ],
                  ),
                ),
              ),
              Container(
                height: screenHeight * 2 / 3,
                decoration: BoxDecoration(
                  color: _isLightMode ? Colors.grey[300] : Colors.grey[900],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SizedBox(
                  child: GridView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 2),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          evaluate(items[index].text);
                        },
                        child: CustomButton(
                          buttonText: items[index].text,
                          isLightMode: _isLightMode,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: size * 25,
          right: -10,
          child: PopupMenuButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  "Light/Dark Mode",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: _mode,
              ),
            ],
            child: _isLightMode
                ? Icon(
                    Icons.more_vert_outlined,
                    color: Colors.black,
                    size: size * 25,
                  )
                : Icon(
                    Icons.more_vert_outlined,
                    color: Colors.white,
                    size: size * 25,
                  ),
          ),
        ),
      ],
    );
  }
}
