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
    compileClassVarDec();
    parseTree += '</class>\n';
    return parseTree;
  }

  // todo: implement
  void compileClassVarDec() {
    parseTree += '<classVarDec>\n';

    parseTree += '</classVarDec>\n';
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
