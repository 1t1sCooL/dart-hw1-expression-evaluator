import 'package:hw1/hw1.dart';

void main(List<String> arguments) {
  final expression = arguments.isEmpty ? '3*x+15/(3+2)' : arguments.join(' ');
  final result = ExpressionEvaluator(expression).evaluate({'x': 10});
  print('$expression = $result');
}
