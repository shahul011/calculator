import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

void main() {
  _expression_creation_and_evaluation();
}

void _expression_creation_and_evaluation() {
  print('\nExample 1: Expression creation and evaluation\n');

  final testCases = [
    {'question': '(25)*25*((85)*98)', 'expectedAnswer': 5206250.0},
    {'question': '2 + 2', 'expectedAnswer': 4.0},
    {'question': '2 * 2', 'expectedAnswer': 4.0},
    {'question': '2 - 2', 'expectedAnswer': 0.0},
    {'question': '2 / 2', 'expectedAnswer': 1.0},
    {'question': 'sqrt(4)', 'expectedAnswer': 2.0},
    {'question': 'sin(${math.pi})', 'expectedAnswer': 0},
    {'question': 'cos(${math.pi})', 'expectedAnswer': -1.0},
    {'question': 'tan(${math.pi})', 'expectedAnswer': 0.0},
  ];

  for (final testCase in testCases) {
    final question = testCase['question']!;
    final expectedAnswer = testCase['expectedAnswer']!;

    print('\nQuestion: $question');
    Parser p = Parser();
    Expression exp = p.parse(question.toString());
    Variable x = Variable('x'), y = Variable('y');
    ContextModel cm = ContextModel()
      ..bindVariable(x, Number(2.0))
      ..bindVariable(y, Number(math.pi));
    double answer = exp.evaluate(EvaluationType.REAL, cm);
    print('Answer: $answer');
    if (answer == expectedAnswer) {
      print('Test case passed!');
    } else {
      print('Test case failed. Expected: $expectedAnswer');
    }
  }
}
