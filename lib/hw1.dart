library;

enum TokenType { number, variable, plus, minus, star, slash, lParen, rParen }

class Token {
  final TokenType type;
  final String text;

  const Token(this.type, this.text);

  @override
  String toString() => 'Token($type, "$text")';
}

bool _isDigit(String ch) {
  final code = ch.codeUnitAt(0);
  return code >= 48 && code <= 57;
}

bool _isLetter(String ch) {
  final code = ch.codeUnitAt(0);
  return (code >= 65 && code <= 90) || (code >= 97 && code <= 122) || ch == '_';
}

List<Token> tokenize(String input) {
  final tokens = <Token>[];
  var i = 0;

  while (i < input.length) {
    final ch = input[i];

    if (ch == ' ' || ch == '\t' || ch == '\n') {
      i++;
      continue;
    }

    if (_isDigit(ch) || ch == '.') {
      final start = i;
      while (i < input.length && (_isDigit(input[i]) || input[i] == '.')) {
        i++;
      }
      tokens.add(Token(TokenType.number, input.substring(start, i)));
      continue;
    }

    if (_isLetter(ch)) {
      final start = i;
      while (i < input.length && (_isLetter(input[i]) || _isDigit(input[i]))) {
        i++;
      }
      tokens.add(Token(TokenType.variable, input.substring(start, i)));
      continue;
    }

    final type = switch (ch) {
      '+' => TokenType.plus,
      '-' => TokenType.minus,
      '*' => TokenType.star,
      '/' => TokenType.slash,
      '(' => TokenType.lParen,
      ')' => TokenType.rParen,
      _ => throw FormatException('Unexpected char "$ch" at $i', input, i),
    };
    tokens.add(Token(type, ch));
    i++;
  }

  return tokens;
}

class ExpressionEvaluator {
  final String expression;

  ExpressionEvaluator(this.expression);

  double evaluate(Map<String, num> variables) {
    final parser = _Parser(tokenize(expression), variables);
    final result = parser.parseExpr();

    if (!parser.isAtEnd) {
      throw FormatException(
        'Unexpected token ${parser.current} after end of expression',
        expression,
      );
    }
    return result;
  }
}

class _Parser {
  final List<Token> _tokens;
  final Map<String, num> _vars;
  int _pos = 0;

  _Parser(this._tokens, this._vars);

  bool get isAtEnd => _pos >= _tokens.length;

  Token? get current => isAtEnd ? null : _tokens[_pos];

  bool _match(TokenType type) {
    if (current?.type == type) {
      _pos++;
      return true;
    }
    return false;
  }

  double parseExpr() {
    var left = parseTerm();
    while (true) {
      if (_match(TokenType.plus)) {
        left += parseTerm();
      } else if (_match(TokenType.minus)) {
        left -= parseTerm();
      } else {
        return left;
      }
    }
  }

  double parseTerm() {
    var left = parseFactor();
    while (true) {
      if (_match(TokenType.star)) {
        left *= parseFactor();
      } else if (_match(TokenType.slash)) {
        left /= parseFactor();
      } else {
        return left;
      }
    }
  }

  double parseFactor() {
    if (_match(TokenType.minus)) {
      return -parseFactor();
    }

    if (_match(TokenType.lParen)) {
      final value = parseExpr();
      if (!_match(TokenType.rParen)) {
        throw FormatException('Expected ")"', null, _pos);
      }
      return value;
    }

    final token = current;
    if (token == null) {
      throw const FormatException('Unexpected end of expression');
    }

    switch (token.type) {
      case TokenType.number:
        _pos++;
        return double.parse(token.text);
      case TokenType.variable:
        _pos++;
        final value = _vars[token.text];
        if (value == null) {
          throw ArgumentError.value(
            token.text,
            'variables',
            'Unknown variable',
          );
        }
        return value.toDouble();
      default:
        throw FormatException('Unexpected token $token', null, _pos);
    }
  }
}
