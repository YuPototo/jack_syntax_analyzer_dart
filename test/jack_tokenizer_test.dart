import 'package:test/test.dart';

import 'package:jack_syntax_analyzer_dart/jack_tokenizer.dart';

void main() {
  group('hasMoreTokens', () {
    test("A simple true", () {
      var scriptContent = 'let x = 5;';
      var tokenizer = JackTokenizer(scriptContent);
      expect(tokenizer.hasMoreTokens(), equals(true));
    });

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

    test('ignore // comment', () {
      var scriptContent = '// comment \n';
      var tokenizer = JackTokenizer(scriptContent);
      expect(tokenizer.hasMoreTokens(), equals(false));
    });

    test('code after // comment', () {
      var scriptContent = '// comment\nlet x = 5;';
      var tokenizer = JackTokenizer(scriptContent);
      expect(tokenizer.hasMoreTokens(), equals(true));
    });

    test('ignore /* comment */', () {
      var scriptContent = '/* comment */';
      var tokenizer = JackTokenizer(scriptContent);
      expect(tokenizer.hasMoreTokens(), equals(false));
    });

    test('code after /* comment */', () {
      var scriptContent = '/* comment */let x = 5;';
      var tokenizer = JackTokenizer(scriptContent);
      expect(tokenizer.hasMoreTokens(), equals(true));
    });

    test('ignore /** comment */', () {
      var scriptContent = '/** comment */';
      var tokenizer = JackTokenizer(scriptContent);
      expect(tokenizer.hasMoreTokens(), equals(false));
    });

    test('code after /** comment */', () {
      var scriptContent = '/** comment */let x = 5;';
      var tokenizer = JackTokenizer(scriptContent);
      expect(tokenizer.hasMoreTokens(), equals(true));
    });
  });
}
