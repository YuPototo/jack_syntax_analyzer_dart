import 'package:test/test.dart';

import 'package:jack_syntax_analyzer_dart/jack_tokenizer.dart';

void main() {
  group('hasMoreTokens', () {
    group('comment', () {
      test('ignore // comment', () {
        var scriptContent = '// comment';
        var tokenizer = JackTokenizer(scriptContent);
        expect(tokenizer.hasMoreTokens(), equals(false));
      });

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
}
