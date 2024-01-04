import 'package:test/test.dart';

import 'package:jack_syntax_analyzer_dart/jack_tokenizer.dart';

void main() {
  group('static removeComments()', () {
    test("remove nothing", () {
      var lines = [''];
      expect(JackTokenizer.removeComments(lines), equals(['']));
    });

    test("remove // ", () {
      var lines = ['// comment'];
      expect(JackTokenizer.removeComments(lines), equals(['']));
    });

    test("remove // with code", () {
      var lines = ['let s = 1 // comment'];
      expect(JackTokenizer.removeComments(lines), equals(['let s = 1 ']));
    });

    test("remove /** comment */", () {
      var lines = ['/** comment */'];
      expect(JackTokenizer.removeComments(lines), equals(['']));
    });

    test("remove /** comment */ with code", () {
      var lines = ['let s = /** comment */ 1'];
      expect(JackTokenizer.removeComments(lines), equals(['let s =  1']));
    });

    test("remove /* comment */", () {
      var lines = ['/* comment */'];
      expect(JackTokenizer.removeComments(lines), equals(['']));
    });

    test("remove /* comment */ with code", () {
      var lines = ['let s = /* comment */ 1'];
      expect(JackTokenizer.removeComments(lines), equals(['let s =  1']));
    });

    test("should not remove // in double quote", () {
      var lines = ['let s = "// comment"'];
      expect(JackTokenizer.removeComments(lines),
          equals(['let s = "// comment"']));
    });

    test("should not remove /** */ inside double quote", () {
      var lines = ['let s = "/** comment */"'];
      expect(JackTokenizer.removeComments(lines),
          equals(['let s = "/** comment */"']));
    });

    test("should not remove /* */ inside double quote", () {
      var lines = ['let s = "/* comment */"'];
      expect(JackTokenizer.removeComments(lines),
          equals(['let s = "/* comment */"']));
    });
  });

  group('static cleanCode', () {
    test('code with empty lines', () {
      var scriptContent = '''

        let s = 1;

        let t = 2;
        ''';
      var cleanScript = JackTokenizer.cleanCode(scriptContent);
      expect(cleanScript, equals(['let s = 1;', 'let t = 2;']));
    });

    test('code with comments', () {
      var scriptContent = '''
        // comment
        let s = 1; // comment
        let t = 2; /* comment */
        ''';
      var cleanScript = JackTokenizer.cleanCode(scriptContent);
      expect(cleanScript, equals(['let s = 1;', 'let t = 2;']));
    });

    test('code with trailing spaces', () {
      var scriptContent = '''
        let s = 1;  
        let t = 2; 
        ''';
      var cleanScript = JackTokenizer.cleanCode(scriptContent);
      expect(cleanScript, equals(['let s = 1;', 'let t = 2;']));
    });
  });

  group('static handleTokenWithSign', () {
    test("2;", () {
      // case: let s = 2;
      var possibleTokens = '2;';
      var tokens = JackTokenizer.handleTokenWithSign(possibleTokens);
      expect(tokens, equals(['2', ';']));
    });

    test("(1", () {
      // case: let s = (1 + 2);
      var possibleTokens = '(1';
      var tokens = JackTokenizer.handleTokenWithSign(possibleTokens);
      expect(tokens, equals(['(', '1']));
    });

    test("2)", () {
      // case: let s = (1 + 2) ; // note the space before ;
      var possibleTokens = '2)';
      var tokens = JackTokenizer.handleTokenWithSign(possibleTokens);
      expect(tokens, equals(['2', ')']));
    });

    test("2)", () {
      // case: let s = (1 + 2);
      var possibleTokens = '2);';
      var tokens = JackTokenizer.handleTokenWithSign(possibleTokens);
      expect(tokens, equals(['2', ')', ';']));
    });

    test("x,", () {
      // case: field int x, y;
      var possibleTokens = 'x,';
      var tokens = JackTokenizer.handleTokenWithSign(possibleTokens);
      expect(tokens, equals(['x', ',']));
    });
  });

  group('static tokenizeLine', () {
    test("semicolon", () {
      var line = 'let s = 1;';
      var tokens = JackTokenizer.tokenizeLine(line);
      expect(tokens, equals(['let', 's', '=', '1', ';']));
    });

    test("semicolon with space", () {
      var line = 'let s = 1 ;';
      var tokens = JackTokenizer.tokenizeLine(line);
      expect(tokens, equals(['let', 's', '=', '1', ';']));
    });

    test("bracket", () {
      var line = 'let s = (1 + 2);';
      var tokens = JackTokenizer.tokenizeLine(line);
      expect(tokens, equals(['let', 's', '=', '(', '1', '+', '2', ')', ';']));
    });

    test('bracket with space', () {
      var line = 'let s = ( 1 + 2 );';
      var tokens = JackTokenizer.tokenizeLine(line);
      expect(tokens, equals(['let', 's', '=', '(', '1', '+', '2', ')', ';']));
    });

    test('comma', () {
      var line = 'field int x, y;';
      var tokens = JackTokenizer.tokenizeLine(line);
      expect(tokens, equals(['field', 'int', 'x', ',', 'y', ';']));
    });
  });

  group('static tokenize', () {
    test('empty code', () {
      var lines = '''
        let s = 1;
        ''';
      var cleanLines = JackTokenizer.cleanCode(lines);
      var tokens = JackTokenizer.tokenize(cleanLines);
      expect(
          tokens,
          equals([
            'let',
            's',
            '=',
            '1',
            ';',
          ]));
    });
  }, skip: "test after tokenizeLine is implemented");
}
