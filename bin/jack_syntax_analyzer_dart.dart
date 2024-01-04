import 'dart:io';
import 'package:args/args.dart';
import 'package:jack_syntax_analyzer_dart/check_path.dart';

void main(List<String> arguments) {
  exitCode = 0; // Presume success
  final parser = ArgParser();

  ArgResults argResults = parser.parse(arguments);
  final path = argResults.rest[0];

  var validFiles = checkPath(path);

  for (var file in validFiles) {
    // print file content
    print(file.readAsStringSync());
  }
}
