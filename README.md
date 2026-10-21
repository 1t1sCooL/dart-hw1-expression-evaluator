# HW1 — интерпретатор математических выражений

Класс `ExpressionEvaluator` принимает строку с выражением, метод `evaluate`
принимает `Map` с переменными и возвращает `double`.

Поддерживается: `+ - * /`, скобки, переменные, дробные числа, унарный минус.

```dart
ExpressionEvaluator('3*x+15/(3+2)').evaluate({'x': 10}); // 33.0
ExpressionEvaluator('-3+5').evaluate({});                // 2.0
```

Запуск:

```
dart run bin/hw1.dart "(x*3-5)/5"
dart test
```
