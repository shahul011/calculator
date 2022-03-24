import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

void main() {
  _expression_creation_and_evaluation();
}

void _expression_creation_and_evaluation() {
  print('\nExample 1: Expression creation and evaluation\n');

  // You can either create an mathematical expression programmatically or parse
  // a string.
  // (1a) Parse expression:
  Parser p = Parser();
  String question = ('(25)*25*((85)*98)');
  Expression exp = p.parse(question);
  Variable x = Variable('x'), y = Variable('y');

  ContextModel cm = ContextModel()
    ..bindVariable(x, Number(2.0))
    ..bindVariable(y, Number(math.pi));
  double answer = exp.evaluate(EvaluationType.REAL, cm);

  print(answer);
}
