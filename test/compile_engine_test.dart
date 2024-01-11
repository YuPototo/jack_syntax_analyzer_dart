import 'package:jack_syntax_analyzer_dart/compile_engine.dart';
import 'package:jack_syntax_analyzer_dart/jack_tokenizer.dart';
import 'package:test/test.dart';

/**
 * 
 * Complile class
 *  - compile subroutine
 *   -   compile subroutine body
 *     -   compile statements
 *        - let
 *           - compileExpression
 *        - if
 *        - while
 *        - do
 *        - return
 */

void main() {
  group('compileClass()', () {
    test('A simple class', () {
      var tokenizer = JackTokenizer('class Main { }');
      var compileEngine = CompileEngine(tokenizer);
      compileEngine.compileClass();
      var expected = '''
<class>
<keyword> class </keyword>
<identifier> Main </identifier>
<symbol> { </symbol>
<symbol> } </symbol>
</class>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('Class with 1 class var declaration', () {
      var tokenizer = JackTokenizer('class Main { static int x; }');
      var compileEngine = CompileEngine(tokenizer);
      compileEngine.compileClass();
      var expected = '''
<class>
<keyword> class </keyword>
<identifier> Main </identifier>
<symbol> { </symbol>
<classVarDec>
<keyword> static </keyword>
<keyword> int </keyword>
<identifier> x </identifier>
<symbol> ; </symbol>
</classVarDec>
<symbol> } </symbol>
</class>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('Class with 2 class var declaration', () {
      var tokenizer = JackTokenizer('''
class Main { 
  static int x, y;
  field int z;
 }
''');
      var compileEngine = CompileEngine(tokenizer);
      compileEngine.compileClass();
      var expected = '''
<class>
<keyword> class </keyword>
<identifier> Main </identifier>
<symbol> { </symbol>
<classVarDec>
<keyword> static </keyword>
<keyword> int </keyword>
<identifier> x </identifier>
<symbol> , </symbol>
<identifier> y </identifier>
<symbol> ; </symbol>
</classVarDec>
<classVarDec>
<keyword> field </keyword>
<keyword> int </keyword>
<identifier> z </identifier>
<symbol> ; </symbol>
</classVarDec>
<symbol> } </symbol>
</class>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });
  });

  group('compileClassVarDec()', () {
    test('a simple static var', () {
      var tokenizer = JackTokenizer('static int x;');
      tokenizer.advance();
      var compileEngine = CompileEngine(tokenizer);
      compileEngine.compileClassVarDec();
      var expected = '''
<classVarDec>
<keyword> static </keyword>
<keyword> int </keyword>
<identifier> x </identifier>
<symbol> ; </symbol>
</classVarDec>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('a simple field var', () {
      var tokenizer = JackTokenizer('field int x;');
      tokenizer.advance();
      var compileEngine = CompileEngine(tokenizer);
      compileEngine.compileClassVarDec();
      var expected = '''
<classVarDec>
<keyword> field </keyword>
<keyword> int </keyword>
<identifier> x </identifier>
<symbol> ; </symbol>
</classVarDec>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('2 static var', () {
      var tokenizer = JackTokenizer('static int x, y;');
      tokenizer.advance();
      var compileEngine = CompileEngine(tokenizer);
      compileEngine.compileClassVarDec();
      var expected = '''
<classVarDec>
<keyword> static </keyword>
<keyword> int </keyword>
<identifier> x </identifier>
<symbol> , </symbol>
<identifier> y </identifier>
<symbol> ; </symbol>
</classVarDec>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('2 field var', () {
      var tokenizer = JackTokenizer('field int x, y;');
      tokenizer.advance();
      var compileEngine = CompileEngine(tokenizer);
      compileEngine.compileClassVarDec();
      var expected = '''
<classVarDec>
<keyword> field </keyword>
<keyword> int </keyword>
<identifier> x </identifier>
<symbol> , </symbol>
<identifier> y </identifier>
<symbol> ; </symbol>
</classVarDec>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });
  });

  // todo
  group('compileSubroutine', () {});

  group('compileParameterList', () {
    test('empty parameter list', () {
      var tokenizer = JackTokenizer('()');
      tokenizer.advance();
      tokenizer.advance(); // pass (
      var compileEngine = CompileEngine(tokenizer);

      compileEngine.compileParameterList();
      var expected = '''
<parameterList>
</parameterList>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('1 parameter', () {
      var tokenizer = JackTokenizer('(int x)');
      tokenizer.advance();
      tokenizer.advance(); // pass (
      var compileEngine = CompileEngine(tokenizer);

      compileEngine.compileParameterList();
      var expected = '''
<parameterList>
<keyword> int </keyword>
<identifier> x </identifier>
</parameterList>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('2 parameters', () {
      var tokenizer = JackTokenizer('(int x, int y)');
      tokenizer.advance();
      tokenizer.advance(); // pass (
      var compileEngine = CompileEngine(tokenizer);

      compileEngine.compileParameterList();
      var expected = '''
<parameterList>
<keyword> int </keyword>
<identifier> x </identifier>
<symbol> , </symbol>
<keyword> int </keyword>
<identifier> y </identifier>
</parameterList>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });
  });

  // todo
  group('compileSubroutineBody', () {});

  group('compileVarDec()', () {
    test('a var', () {
      var tokenizer = JackTokenizer('var int x;');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileVarDec();
      var expected = '''
<varDec>
<keyword> var </keyword>
<keyword> int </keyword>
<identifier> x </identifier>
<symbol> ; </symbol>
</varDec>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('2 vars', () {
      var tokenizer = JackTokenizer('var int x, y;');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileVarDec();
      var expected = '''
<varDec>
<keyword> var </keyword>
<keyword> int </keyword>
<identifier> x </identifier>
<symbol> , </symbol>
<identifier> y </identifier>
<symbol> ; </symbol>
</varDec>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });
  });

  // todo
  group('compileStatements', () {});

  // todo
  group('compileLet', () {
    test('let x = 1;', () {
      var tokenizer = JackTokenizer('let x = 1;');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileStatements();
      var expected = '''
<letStatement>
  <keyword> let </keyword>
  <identifier> x </identifier>
  <symbol> = </symbol>
  <expression>
    <term>
      <integerConstant> 1 </integerConstant>
    </term>
  </expression>
  <symbol> ; </symbol>
</letStatement>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('let x = y;', () {
      var tokenizer = JackTokenizer('let x = y;');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileStatements();
      var expected = '''
<letStatement>
  <keyword> let </keyword>
  <identifier> x </identifier>
  <symbol> = </symbol>
  <expression>
      <term>
          <identifier> Ax </identifier>
      </term>
  </expression>
  <symbol> ; </symbol>
</letStatement>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });
  }, skip: true);

  group('compileExpression', () {
    test('x > 1', () {
      var tokenizer = JackTokenizer('x > 1');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileExpression();
      var expected = '''
???
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    }, skip: true);
  });
}
