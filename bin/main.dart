import 'dart:io';
import 'package:args/args.dart';
import 'package:jack_syntax_analyzer_dart/jack_analyzer.dart';

void main(List<String> arguments) {
  exitCode = 0; // Presume success
  final parser = ArgParser();

  ArgResults argResults = parser.parse(arguments);
  final path = argResults.rest[0];

  var analyzer = JackAnalyzer(path);

  analyzer.generateTokenizedOutput();
}
