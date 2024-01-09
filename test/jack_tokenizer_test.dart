import 'package:test/test.dart';

import 'package:jack_syntax_analyzer_dart/jack_tokenizer.dart';

void main() {
  group('hasMoreTokens()', () {
    group('comment', () {
      test('ignore // comment \n', () {
        var scriptContent = '// comment \n';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(false));
      });

      test('ignore /* comment */', () {
        var scriptContent = '/* comment */';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(false));
      });

      test('ignore /** comment */', () {
        var scriptContent = '/* comment */';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(false));
      });

      test('code after // comment', () {
        var scriptContent = '// comment\nlet x = 5;';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(true));
      });

      test('code after /* comment */', () {
        var scriptContent = '/* comment */let x = 5;';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(true));
      });

      test('code after /** comment */', () {
        var scriptContent = '/** comment */let x = 5;';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(true));
      });
    });

    group('handle empty space and newlines', () {
      test("A simple false", () {
        var scriptContent = '';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(false));
      });

      test('Ignore whitespace', () {
        var scriptContent = '  ';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(false));
      });

      test('Ignore newlines', () {
        var scriptContent = '\n';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(false));
      });

      test('Ignore whitespace and newlines', () {
        var scriptContent = '  \n';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(false));
      });

      test('Token after new line and whitespace', () {
        var scriptContent = '  \n let x = 5;';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(true));
      });
    });

    group('has more token', () {
      test("A simple true", () {
        var scriptContent = 'let x = 5;';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(true));
      });

      test("a symbol ;", () {
        var scriptContent = ';';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(true));
      });

      test("integer", () {
        var scriptContent = '30';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(true));
      });

      test("string constant", () {
        var scriptContent = '"ha"';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(true));
      });

      test("a keyword", () {
        var scriptContent = 'field';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(true));
      });

      test("an identifier", () {
        var scriptContent = 'var_name';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(true));
      });
    });
  });

  group('advance()', () {
    group('Simple tokens separated by whitespace', () {
      test('keyword', () {
        var scriptContent = 'let x = 5;';
        var tokenizer = JackTokenizer(scriptContent);
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('let'));
      });

      test('identifiers', () {
        var scriptContent = 'let x = 5;';
        var tokenizer = JackTokenizer(scriptContent);
        tokenizer.advance();
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('x'));
      });

      test('symbol', () {
        var scriptContent = 'let x = 5;';
        var tokenizer = JackTokenizer(scriptContent);
        tokenizer.advance();
        tokenizer.advance();
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('='));
      });
    });

    group('no whitespace case', () {
      test('(x', () {
        // if (x > 5) {}
        var scriptContent = '(x';
        var tokenizer = JackTokenizer(scriptContent);
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('('));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('x'));
      });

      test('x)', () {
        // if (x > 5) {}
        var scriptContent = 'x)';
        var tokenizer = JackTokenizer(scriptContent);
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('x'));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals(')'));
      });

      test('5;', () {
        // let x = 5;
        var scriptContent = '5;';
        var tokenizer = JackTokenizer(scriptContent);
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('5'));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals(';'));
      });

      test('a[i];', () {
        // let x = a[i];
        var scriptContent = 'a[i];';
        var tokenizer = JackTokenizer(scriptContent);
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('a'));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('['));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('i'));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals(']'));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals(';'));
      });

      test('class membership .', () {
        //  Car.new()
        var scriptContent = 'Car.new()';
        var tokenizer = JackTokenizer(scriptContent);
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('Car'));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('.'));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('new'));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('('));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals(')'));
      });

      test('variable list separator ,', () {
        var scriptContent = 'let x, y;';
        var tokenizer = JackTokenizer(scriptContent);
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('let'));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('x'));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals(','));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('y'));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals(';'));
      });
    });

    group('comments', () {
      test('handle // comment', () {
        var scriptContent = '// comment\nlet x = 5;';
        var tokenizer = JackTokenizer(scriptContent);
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('let'));
      });

      test('handle /** comment */', () {
        var scriptContent = '/** 1 */let x= 5;';
        var tokenizer = JackTokenizer(scriptContent);
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('let'));
      });

      test('handle /* comment */', () {
        var scriptContent = '/* 1 */let x = 5;';
        var tokenizer = JackTokenizer(scriptContent);
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('let'));
      });
    });

    group('string constants', () {
      test('handle string constant', () {
        var scriptContent = '"ha"';
        var tokenizer = JackTokenizer(scriptContent);
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('"ha"'));
      });

      test('handle string constant with whitespace', () {
        var scriptContent = '"ha ha"';
        var tokenizer = JackTokenizer(scriptContent);
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('"ha ha"'));
      });

      test('A string assignment', () {
        var scriptContent = 'let x = "abc";';
        var tokenizer = JackTokenizer(scriptContent);

        tokenizer.advance();
        expect(tokenizer.currentToken, equals('let'));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('x'));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('='));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals('"abc"'));
        tokenizer.advance();
        expect(tokenizer.currentToken, equals(';'));
      });
    });
  });

  group('handleComment()', () {
    test('handle // comment', () {
      var scriptContent = '// comment\n';
      int endCommentCursor = JackTokenizer.handleComment(scriptContent, 0);
      expect(endCommentCursor, equals(10));
    });

    test('handle /** comment */', () {
      var scriptContent = '/** 1 */';
      int endCommentCursor = JackTokenizer.handleComment(scriptContent, 0);
      expect(endCommentCursor, equals(7));
    });

    test('handle /* comment */', () {
      var scriptContent = '/* 1 */';
      int endCommentCursor = JackTokenizer.handleComment(scriptContent, 0);
      expect(endCommentCursor, equals(6));
    });
  });

  group('handleStringConstant()', () {
    test('', () {
      var scriptContent = '"ha"';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.cursor = 0;
      tokenizer.handleStringConstant();
      expect(tokenizer.currentToken, equals('"ha"'));
      expect(tokenizer.cursor, equals(3));
    });
  });

  group('tokenType()', () {
    test('keyword', () {
      var scriptContent = 'class';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.tokenType(), equals(TokenType.keyword));
    });

    test('symbol', () {
      var scriptContent = '{';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.tokenType(), equals(TokenType.symbol));
    });

    test('stringConstant', () {
      var scriptContent = '"ha"';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.tokenType(), equals(TokenType.stringConstant));
    });

    test('identifier', () {
      var scriptContent = 'x';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.tokenType(), equals(TokenType.identifier));
    });

    test('intConstant', () {
      var scriptContent = '5';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.tokenType(), equals(TokenType.intConstant));
    });
  });

  group('keyword()', () {
    test('class', () {
      var scriptContent = 'class';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.keyword(), equals('CLASS'));
    });

    test('TRUE', () {
      var scriptContent = 'true';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.keyword(), equals('TRUE'));
    });
  });

  group('symbol()', () {
    test('{', () {
      var scriptContent = '{';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.symbol(), equals('{'));
    });

    test('}', () {
      var scriptContent = '}';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.symbol(), equals('}'));
    });

    test('<', () {
      var scriptContent = '<';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.symbol(), equals('&lt;'));
    });

    test('>', () {
      var scriptContent = '>';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.symbol(), equals('&gt;'));
    });

    test('&', () {
      var scriptContent = '&';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.symbol(), equals('&amp;'));
    });
  });

  group('identifier()', () {
    test('x', () {
      var scriptContent = 'x';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.identifier(), equals('x'));
    });

    test('x_5', () {
      var scriptContent = 'x_5';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.identifier(), equals('x_5'));
    });
  });

  group('intVal()', () {
    test('5', () {
      var scriptContent = '5';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.intVal(), equals(5));
    });
  });

  group('stringVal()', () {
    test('"ha"', () {
      var scriptContent = '"ha"';
      var tokenizer = JackTokenizer(scriptContent);
      tokenizer.advance();
      expect(tokenizer.stringVal(), equals('ha'));
    });
  });
}
