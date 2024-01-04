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
  });
}
