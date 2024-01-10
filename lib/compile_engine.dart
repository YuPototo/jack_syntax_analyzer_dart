import 'package:jack_syntax_analyzer_dart/jack_tokenizer.dart';

class CompileEngine {
  JackTokenizer tokenizer;
  String parseTree = '';

  CompileEngine(this.tokenizer);

  String compileClass() {
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

    //  process('}');

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
    process(tokenizer.currentToken!); // constructor | function | method
    process(tokenizer.currentToken!); // void | type
    process(tokenizer.currentToken!); // subroutineName
    process('(');
    compileParameterList();
    process(')');
    compileSubroutineBody();
  }

  // handle in next project
  void compileParameterList() {
    parseTree += '<parameterList>\n';
    parseTree += '</parameterList>\n';
  }

  void compileSubroutineBody() {
    parseTree += '<subroutineBody>\n';
    process('{');

    while (tokenizer.currentToken == 'var') {
      // todo: here
      // compileVarDec();
    }

    // todo: here
    // compileStatements();

    process('}');
    parseTree += '</subroutineBody>\n';
  }

  /// Compiles a terminal. If the current token is an identifier, the routine must distinguish between a variable, an array entry, and a subroutine call.
  void compileTerm() {
    // todo
  }

  void process(String token) {
    if (tokenizer.currentToken == token) {
      String tokenType = tokenizer.tokenType();
      parseTree += '<$tokenType> ${tokenizer.currentToken} </$tokenType>\n';
      tokenizer.advance();
    } else {
      throw Exception('Expected $token but got ${tokenizer.currentToken}');
    }
  }
}
