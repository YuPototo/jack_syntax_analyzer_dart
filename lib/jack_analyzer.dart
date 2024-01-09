import 'dart:io';

import 'package:jack_syntax_analyzer_dart/check_path.dart';
import 'package:jack_syntax_analyzer_dart/jack_tokenizer.dart';

class JackAnalyzer {
  // generate xxxT.xml file

  String path;

  JackAnalyzer(this.path);

  /// Generate tokenized output of Jack files
  void generateTokenizedOutput() {
    // read file
    var files = checkPath(path);

    for (var file in files) {
      var scriptContent = file.readAsStringSync();
      var tokenizedOutput = tokenize(scriptContent);
      var tokenizedOutputFile = file.path.replaceAll('.jack', 'T.xml');
      File(tokenizedOutputFile).writeAsStringSync(tokenizedOutput);
    }
  }

  String tokenize(String scriptContent) {
    var output = '';

    output += '<tokens>\n';

    var tokenizer = JackTokenizer(scriptContent);

    while (tokenizer.hasMoreTokens()) {
      tokenizer.advance();
      var tokenType = tokenizer.tokenType();
      if (tokenType == TokenType.stringConstant) {
        var stringVal = tokenizer.stringVal();
        output += '<stringConstant> $stringVal </stringConstant>\n';
        continue;
      } else if (tokenType == TokenType.identifier) {
        var identifier = tokenizer.identifier();
        output += '<identifier> $identifier </identifier>\n';
        continue;
      } else if (tokenType == TokenType.intConstant) {
        var intVal = tokenizer.intVal();
        output += '<integerConstant> $intVal </integerConstant>\n';
        continue;
      } else if (tokenType == TokenType.symbol) {
        var symbol = tokenizer.symbol();
        output += '<symbol> $symbol </symbol>\n';
        continue;
      } else if (tokenType == TokenType.keyword) {
        var keyword = tokenizer.keyword();
        output += '<keyword> $keyword </keyword>\n';
        continue;
      }
    }

    output += '</tokens>\n';
    return output;
  }
}
