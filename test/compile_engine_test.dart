import 'package:jack_syntax_analyzer_dart/compile_engine.dart';
import 'package:jack_syntax_analyzer_dart/jack_tokenizer.dart';
import 'package:test/test.dart';

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

  group('compileSubroutine', () {
    test('a simple constructor', () {
      var tokenizer = JackTokenizer('function void main() {}');
      tokenizer.advance();
      var compileEngine = CompileEngine(tokenizer);
      compileEngine.compileSubroutine();
      var expected = '''
<subroutineDec>
  <keyword> function </keyword>
    <keyword> void </keyword>
    <identifier> main </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
        <statements>
        </statements>
      <symbol> } </symbol>
    </subroutineBody>
</subroutineDec>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('with varDec', () {
      var tokenizer = JackTokenizer('''
    function void main() {
        var SquareGame game;
    }
''');
      tokenizer.advance();
      var compileEngine = CompileEngine(tokenizer);
      compileEngine.compileSubroutine();
      var expected = '''
<subroutineDec>
  <keyword> function </keyword>
    <keyword> void </keyword>
    <identifier> main </identifier>
    <symbol> ( </symbol>
      <parameterList>
      </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
        <varDec>
          <keyword> var </keyword>
          <identifier> SquareGame </identifier>
          <identifier> game </identifier>
          <symbol> ; </symbol>
        </varDec>
        <statements>
        </statements>
      <symbol> } </symbol>
    </subroutineBody>
</subroutineDec>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('with statements', () {
      var tokenizer = JackTokenizer('''
    function void main() {
        return;
    }
''');
      tokenizer.advance();
      var compileEngine = CompileEngine(tokenizer);
      compileEngine.compileSubroutine();
      var expected = '''
<subroutineDec>
  <keyword> function </keyword>
    <keyword> void </keyword>
    <identifier> main </identifier>
    <symbol> ( </symbol>
      <parameterList>
      </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
        <statements>
          <returnStatement>
            <keyword> return </keyword>
            <symbol> ; </symbol>
          </returnStatement>
        </statements>
      <symbol> } </symbol>
    </subroutineBody>
</subroutineDec>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });
  });

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

  group('compileSubroutineBody', () {
    test('empty body', () {
      var tokenizer = JackTokenizer('{}');
      var compileEngine = CompileEngine(tokenizer);

      tokenizer.advance();

      compileEngine.compileSubroutineBody();

      var expected = '''
<subroutineBody>
<symbol> { </symbol>
    <statements>
    </statements>
<symbol> } </symbol>
</subroutineBody>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });
  });

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

  group('compileStatements', () {
    test('empty statement', () {
      var tokenizer = JackTokenizer('{}');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      tokenizer.advance(); // pass {
      compileEngine.compileStatements();
      var expected = '''
<statements>
</statements>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('letStatement', () {
      var tokenizer = JackTokenizer('{ let x = 1; }');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      tokenizer.advance(); // pass {
      compileEngine.compileStatements();
      var expected = '''
<statements>
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
</statements>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('two letStatement', () {
      var tokenizer = JackTokenizer('{ let x = 1; let y = 2; }');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      tokenizer.advance(); // pass {
      compileEngine.compileStatements();
      var expected = '''
<statements>
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
  <letStatement>
    <keyword> let </keyword>
    <identifier> y </identifier>
    <symbol> = </symbol>
    <expression>
        <term>
            <integerConstant> 2 </integerConstant>
        </term>
    </expression>
    <symbol> ; </symbol>
  </letStatement>
</statements>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });
  });

  group('compileLet', () {
    test('let x = 1;', () {
      var tokenizer = JackTokenizer('let x = 1;');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileLet();
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
      compileEngine.compileLet();
      var expected = '''
<letStatement>
  <keyword> let </keyword>
  <identifier> x </identifier>
  <symbol> = </symbol>
  <expression>
      <term>
          <identifier> y </identifier>
      </term>
  </expression>
  <symbol> ; </symbol>
</letStatement>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('let game = SquareGame.new();', () {
      var tokenizer = JackTokenizer('let game = SquareGame.new();');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileLet();
      var expected = '''
<letStatement>
  <keyword> let </keyword>
  <identifier> game </identifier>
  <symbol> = </symbol>
  <expression>
    <term>
      <identifier> SquareGame </identifier>
      <symbol> . </symbol>
      <identifier> new </identifier>
      <symbol> ( </symbol>
      <expressionList>
      </expressionList>
      <symbol> ) </symbol>
    </term>
  </expression>
  <symbol> ; </symbol>
</letStatement>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('let a[1] = a[2]', () {
      var tokenizer = JackTokenizer('let a[1] = a[2];');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileLet();
      var expected = '''
<letStatement>
  <keyword> let </keyword>
  <identifier> a </identifier>
  <symbol> [ </symbol>
  <expression>
    <term>
      <integerConstant> 1 </integerConstant>
    </term>
  </expression>
  <symbol> ] </symbol>
  <symbol> = </symbol>
  <expression>
      <term>
        <identifier> a </identifier>
        <symbol> [ </symbol>
        <expression>
          <term>
            <integerConstant> 2 </integerConstant>
          </term>
        </expression>
        <symbol> ] </symbol>
      </term>
  </expression>
  <symbol> ; </symbol>
</letStatement>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });
  });

  group('compileIf', () {
    test('if (x) {}', () {
      var tokenizer = JackTokenizer('if (x) {}');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileIf();
      var expected = '''
<ifStatement>
<keyword> if </keyword>
<symbol> ( </symbol>
<expression>
    <term>
        <identifier> x </identifier>
    </term>
</expression>
<symbol> ) </symbol>
<symbol> { </symbol>
<statements>
</statements>
<symbol> } </symbol>
</ifStatement>
    ''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('if (x) { } else {}', () {
      var tokenizer = JackTokenizer('if (x) { } else {}');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileIf();
      var expected = '''
<ifStatement>
  <keyword> if </keyword>
  <symbol> ( </symbol>
  <expression>
      <term>
          <identifier> x </identifier>
      </term>
  </expression>
  <symbol> ) </symbol>
  <symbol> { </symbol>
  <statements>
  </statements>
  <symbol> } </symbol>
  <keyword> else </keyword>
  <symbol> { </symbol>
  <statements>
  </statements>
  <symbol> } </symbol>
</ifStatement>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });
  });

  group('compileWhile', () {
    test('while (x) {}', () {
      var tokenizer = JackTokenizer('while (x) {}');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileWhile();
      var expected = '''
<whileStatement>
<keyword> while </keyword>
<symbol> ( </symbol>
<expression>
    <term>
        <identifier> x </identifier>
    </term>
</expression>
<symbol> ) </symbol>
<symbol> { </symbol>
<statements>
</statements>
<symbol> } </symbol>
</whileStatement>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });
  });

  group('compileExpression', () {
    test('1', () {
      // let x = 1;
      var tokenizer = JackTokenizer('1');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileExpression();
      var expected = '''
<expression>
    <term>
        <integerConstant> 1 </integerConstant>
    </term>
</expression>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('x', () {
      // let y = x;
      var tokenizer = JackTokenizer('x');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileExpression();
      var expected = '''
<expression>
    <term>
        <identifier> x </identifier>
    </term>
</expression>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('SquareGame.new()', () {
      // let game = SquareGame.new();
      var tokenizer = JackTokenizer('SquareGame.new()');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileExpression();
      var expected = '''
<expression>
  <term>
      <identifier> SquareGame </identifier>
      <symbol> . </symbol>
      <identifier> new </identifier>
      <symbol> ( </symbol>
      <expressionList>
      </expressionList>
      <symbol> ) </symbol>
    </term> 
</expression>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('x < 254', () {
      var tokenizer = JackTokenizer('x < 254');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileExpression();
      var expected = '''
<expression>
    <term>
        <identifier> x </identifier>
    </term>
    <symbol> &lt; </symbol>
    <term>
        <integerConstant> 254 </integerConstant>
    </term>
</expression>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test(' (x + size) > 510', () {
      // if ((x + size) > 510) {}
      var tokenizer = JackTokenizer('(x + size) > 510');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileExpression();
      var expected = '''
<expression>
  <term>
    <symbol> ( </symbol>
      <expression>
        <term>
          <identifier> x </identifier>
        </term>
        <symbol> + </symbol>
        <term>
          <identifier> size </identifier>
        </term>
      </expression>
      <symbol> ) </symbol>
  </term>
  <symbol> &gt; </symbol>
  <term>
    <integerConstant> 510 </integerConstant>
  </term>
</expression>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });
  });

  group('compileTerm', () {
    test('integerConstant', () {
      var tokenizer = JackTokenizer('1');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileTerm();
      var expected = '''
    <term>
        <integerConstant> 1 </integerConstant>
    </term>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('stringConstant', () {
      var tokenizer = JackTokenizer('"string"');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileTerm();
      var expected = '''
    <term>
        <stringConstant> string </stringConstant>
    </term>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('keyword constant', () {
      var tokenizer = JackTokenizer('true');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileTerm();
      var expected = '''
    <term>
        <keyword> true </keyword> 
    </term>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('varName', () {
      var tokenizer = JackTokenizer('x');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileTerm();
      var expected = '''
    <term>
        <identifier> x </identifier> 
    </term>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('(expression)', () {
      var tokenizer = JackTokenizer('(x)');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileTerm();
      var expected = '''
    <term>
        <symbol> ( </symbol>
        <expression>
            <term>
                <identifier> x </identifier> 
            </term>
        </expression>
        <symbol> ) </symbol>
    </term>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('unaryOp term', () {
      var tokenizer = JackTokenizer('-x');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileTerm();
      var expected = '''
    <term>
        <symbol> - </symbol>
        <term>
            <identifier> x </identifier> 
        </term>
    </term>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('varName[expression]', () {}, skip: true);
  });

  group('compileDo', () {
    test('do moveSquare();', () {
      var tokenizer = JackTokenizer('do moveSquare();');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileDo();
      var expected = '''
<doStatement>
<keyword> do </keyword>
<identifier> moveSquare </identifier>
<symbol> ( </symbol>
<expressionList>
</expressionList>
<symbol> ) </symbol>
<symbol> ; </symbol>
</doStatement>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });

    test('do square.dispose();', () {
      var tokenizer = JackTokenizer('do square.dispose();');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileDo();
      var expected = '''
<doStatement>
<keyword> do </keyword>
<identifier> square </identifier>
<symbol> . </symbol>
<identifier> dispose </identifier>
<symbol> ( </symbol>
<expressionList>
</expressionList>
<symbol> ) </symbol>
<symbol> ; </symbol>
</doStatement>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });
  });

  group('compileReturn', () {
    test('return;', () {
      var tokenizer = JackTokenizer('return;');
      var compileEngine = CompileEngine(tokenizer);
      tokenizer.advance();
      compileEngine.compileReturn();
      var expected = '''
<returnStatement>
<keyword> return </keyword>
<symbol> ; </symbol>
</returnStatement>
''';
      expect(compileEngine.parseTree, equalsIgnoringWhitespace(expected));
    });
  });
}
