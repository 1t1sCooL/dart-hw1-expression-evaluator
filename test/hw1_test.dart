import 'package:hw1/hw1.dart';
import 'package:test/test.dart';

void main() {
  final vars = {'x': 10};

  double eval(String expr, [Map<String, num>? variables]) =>
      ExpressionEvaluator(expr).evaluate(variables ?? vars);

  group('выражения из ТЗ (x = 10)', () {
    test(
      '10*5+4/2-1 = 51',
      () => expect(eval('10*5+4/2-1'), closeTo(51, 1e-9)),
    );
    test('(x*3-5)/5 = 5', () => expect(eval('(x*3-5)/5'), closeTo(5, 1e-9)));
    test('3*x+15/(3+2) = 33', () {
      expect(eval('3*x+15/(3+2)'), closeTo(33, 1e-9));
    });
  });

  group('сочетание операций', () {
    test('2+3*4 = 14 (умножение раньше сложения)', () {
      expect(eval('2+3*4'), closeTo(14, 1e-9));
    });
    test('10-5-2 = 3 (левая ассоциативность)', () {
      expect(eval('10-5-2'), closeTo(3, 1e-9));
    });
    test('8/2/2 = 2 (левая ассоциативность)', () {
      expect(eval('8/2/2'), closeTo(2, 1e-9));
    });
    test('пробелы игнорируются', () {
      expect(eval(' 2 + 3 * 4 '), closeTo(14, 1e-9));
    });
    test('дробные числа: 0.5*4+1.25 = 3.25', () {
      expect(eval('0.5*4+1.25'), closeTo(3.25, 1e-9));
    });
  });

  group('скобки', () {
    test('(2+3)*4 = 20', () => expect(eval('(2+3)*4'), closeTo(20, 1e-9)));
    test('((1+2)*(3+4)) = 21', () {
      expect(eval('((1+2)*(3+4))'), closeTo(21, 1e-9));
    });
    test('2*(x-(3+2)) = 10', () {
      expect(eval('2*(x-(3+2))'), closeTo(10, 1e-9));
    });
  });

  group('унарный минус', () {
    test('-3+5 = 2', () => expect(eval('-3+5'), closeTo(2, 1e-9)));
    test('2*-3 = -6', () => expect(eval('2*-3'), closeTo(-6, 1e-9)));
    test('-(2+3) = -5', () => expect(eval('-(2+3)'), closeTo(-5, 1e-9)));
    test('--3 = 3', () => expect(eval('--3'), closeTo(3, 1e-9)));
    test('-x*2 = -20', () => expect(eval('-x*2'), closeTo(-20, 1e-9)));
    test('5--3 = 8', () => expect(eval('5--3'), closeTo(8, 1e-9)));
  });

  group('переменные', () {
    test('несколько переменных: a*b+c', () {
      expect(eval('a*b+c', {'a': 2, 'b': 3, 'c': 4}), closeTo(10, 1e-9));
    });
    test('имя из нескольких символов', () {
      expect(eval('rate_1*2', {'rate_1': 1.5}), closeTo(3, 1e-9));
    });
  });

  group('ошибки', () {
    test('неизвестная переменная', () {
      expect(() => eval('y+1'), throwsArgumentError);
    });
    test('незакрытая скобка', () {
      expect(() => eval('(1+2'), throwsFormatException);
    });
    test('лишняя закрывающая скобка', () {
      expect(() => eval('1+2)'), throwsFormatException);
    });
    test('недопустимый символ', () {
      expect(() => eval('2^3'), throwsFormatException);
    });
    test('оборванное выражение', () {
      expect(() => eval('2+'), throwsFormatException);
    });
  });
}
