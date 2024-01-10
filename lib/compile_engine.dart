import 'package:jack_syntax_analyzer_dart/jack_tokenizer.dart';

class CompileEngine {
  JackTokenizer tokenizer;
  String parseTree = '';

  CompileEngine(this.tokenizer);

  String compileClass() {
    parseTree += '<class>\n';
    process('class');
    parseTree += '</class>\n';
    return parseTree;
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
