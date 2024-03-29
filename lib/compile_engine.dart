import 'package:jack_syntax_analyzer_dart/jack_tokenizer.dart';

const specialSymboList = ['<', '>', '&'];

class CompileEngine {
  JackTokenizer tokenizer;
  String parseTree = '';

  CompileEngine(this.tokenizer);

  String compileClass() {
    tokenizer.advance();
    parseTree += '<class>\n';
    process('class');
    process(tokenizer.currentToken!);
    process('{');

    while (tokenizer.currentToken == 'static' ||
        tokenizer.currentToken == 'field') {
      compileClassVarDec();
    }

    while (tokenizer.currentToken == 'constructor' ||
        tokenizer.currentToken == 'function' ||
        tokenizer.currentToken == 'method') {
      compileSubroutine();
    }

    process('}');

    parseTree += '</class>\n';
    return parseTree;
  }

  void compileClassVarDec() {
    parseTree += '<classVarDec>\n';

    process(tokenizer.currentToken!); // static | field
    process(tokenizer.currentToken!); // type

    while (tokenizer.currentToken != ';') {
      process(tokenizer.currentToken!); // varName
      if (tokenizer.currentToken == ',') {
        process(',');
      }
    }
    process(";");

    parseTree += '</classVarDec>\n';
  }

  void compileSubroutine() {
    parseTree += '<subroutineDec>\n';
    process(tokenizer.currentToken!); // constructor | function | method
    process(tokenizer.currentToken!); // void | type
    process(tokenizer.currentToken!); // subroutineName
    process('(');
    compileParameterList();
    process(')');
    compileSubroutineBody();
    parseTree += '</subroutineDec>\n';
  }

  void compileParameterList() {
    parseTree += '<parameterList>\n';

    while (tokenizer.currentToken != ')') {
      process(tokenizer.currentToken!); // type
      process(tokenizer.currentToken!); // varName
      if (tokenizer.currentToken == ',') {
        process(',');
      }
    }
    parseTree += '</parameterList>\n';
  }

  void compileSubroutineBody() {
    parseTree += '<subroutineBody>\n';
    process('{');

    while (tokenizer.currentToken == 'var') {
      compileVarDec();
    }

    compileStatements();

    process('}');
    parseTree += '</subroutineBody>\n';
  }

  /// Compiles a terminal. If the current token is an identifier, the routine must distinguish between a variable, an array entry, and a subroutine call.
  void compileTerm() {
    parseTree += '<term>\n';

    if (tokenizer.tokenType() == 'integerConstant' ||
        tokenizer.tokenType() == 'stringConstant' ||
        tokenizer.tokenType() == 'keyword') {
      process(tokenizer.currentToken!);
    } else if (tokenizer.currentToken == '(') {
      process('(');
      compileExpression();
      process(')');
    } else if (tokenizer.currentToken == '-' || tokenizer.currentToken == '~') {
      process(tokenizer.currentToken!);
      compileTerm();
    } else if (tokenizer.tokenType() == 'identifier') {
      process(tokenizer.currentToken!);
      if (tokenizer.currentToken == '[') {
        process('[');
        compileExpression();
        process(']');
      } else if (tokenizer.currentToken == '(') {
        process('(');
        compileExpressionList();
        process(')');
      } else if (tokenizer.currentToken == '.') {
        process('.');
        process(tokenizer.currentToken!); // subroutineName
        process('(');
        compileExpressionList();
        process(')');
      }
    }

    parseTree += '</term>\n';
  }

  void compileVarDec() {
    parseTree += '<varDec>\n';
    process('var');
    process(tokenizer.currentToken!); // type

    while (tokenizer.currentToken != ';') {
      process(tokenizer.currentToken!); // varName
      if (tokenizer.currentToken == ',') {
        process(',');
      }
    }
    process(';');
    parseTree += '</varDec>\n';
  }

  void compileStatements() {
    parseTree += '<statements>\n';
    while (tokenizer.currentToken == 'let' ||
        tokenizer.currentToken == 'if' ||
        tokenizer.currentToken == 'while' ||
        tokenizer.currentToken == 'do' ||
        tokenizer.currentToken == 'return') {
      if (tokenizer.currentToken == 'let') {
        compileLet();
      } else if (tokenizer.currentToken == 'if') {
        compileIf();
      } else if (tokenizer.currentToken == 'while') {
        compileWhile();
      } else if (tokenizer.currentToken == 'do') {
        compileDo();
      } else if (tokenizer.currentToken == 'return') {
        compileReturn();
      }
    }
    parseTree += '</statements>\n';
  }

  void compileLet() {
    parseTree += '<letStatement>\n';
    process('let');
    process(tokenizer.currentToken!); // varName

    if (tokenizer.currentToken == '[') {
      process('[');
      compileExpression();
      process(']');
    }

    process('=');

    compileExpression();

    process(';');
    parseTree += '</letStatement>\n';
  }

  void compileIf() {
    parseTree += '<ifStatement>\n';
    process('if');
    process('(');
    compileExpression();
    process(')');
    process('{');
    compileStatements();
    process('}');
    if (tokenizer.currentToken == 'else') {
      process('else');
      process('{');
      compileStatements();
      process('}');
    }
    parseTree += '</ifStatement>\n';
  }

  void compileWhile() {
    parseTree += '<whileStatement>\n';
    process('while');
    process('(');
    compileExpression();
    process(')');
    process('{');
    compileStatements();
    process('}');
    parseTree += '</whileStatement>\n';
  }

  void compileExpression() {
    parseTree += '<expression>\n';
    compileTerm();
    while (tokenizer.currentToken == '+' ||
        tokenizer.currentToken == '-' ||
        tokenizer.currentToken == '*' ||
        tokenizer.currentToken == '/' ||
        tokenizer.currentToken == '&' ||
        tokenizer.currentToken == '|' ||
        tokenizer.currentToken == '<' ||
        tokenizer.currentToken == '>' ||
        tokenizer.currentToken == '=') {
      process(tokenizer.currentToken!);
      compileTerm();
    }
    parseTree += '</expression>\n';
  }

  void compileDo() {
    parseTree += '<doStatement>\n';
    process('do');
    process(tokenizer.currentToken!); // subroutineName | className | varName
    if (tokenizer.currentToken == '.') {
      process('.');
      process(tokenizer.currentToken!); // subroutineName
    }
    process('(');
    compileExpressionList();
    process(')');
    process(';');
    parseTree += '</doStatement>\n';
  }

  void compileExpressionList() {
    parseTree += '<expressionList>\n';
    while (tokenizer.currentToken != ')') {
      compileExpression();
      if (tokenizer.currentToken == ',') {
        process(',');
      }
    }
    parseTree += '</expressionList>\n';
  }

  void compileReturn() {
    parseTree += '<returnStatement>\n';
    process('return');
    if (tokenizer.currentToken != ';') {
      compileExpression();
    }
    process(';');
    parseTree += '</returnStatement>\n';
  }

  void process(String token) {
    if (tokenizer.currentToken == token) {
      String tokenType = tokenizer.tokenType();
      if (tokenType == 'stringConstant') {
        int endIndex = tokenizer.currentToken!.length - 1;
        String tokenWithoutQuotes =
            tokenizer.currentToken!.substring(1, endIndex);
        parseTree += '<$tokenType> $tokenWithoutQuotes </$tokenType>\n';
      } else {
        if (tokenType == 'symbol' && specialSymboList.contains(token)) {
          if (token == '&') {
            parseTree += '<$tokenType> &amp; </$tokenType>\n';
          } else if (token == '<') {
            parseTree += '<$tokenType> &lt; </$tokenType>\n';
          } else if (token == '>') {
            parseTree += '<$tokenType> &gt; </$tokenType>\n';
          }
        } else {
          parseTree += '<$tokenType> ${tokenizer.currentToken} </$tokenType>\n';
        }
      }
      tokenizer.advance();
    } else {
      throw Exception('Expected $token but got ${tokenizer.currentToken}');
    }
  }
}
