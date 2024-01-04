class JackTokenizer {
  List<String> tokens;

  JackTokenizer(String scriptContent) : tokens = [] {
    // List<String> cleanScript = cleanCode(scriptContent);
    // tokens = tokenize(cleanScript);
  }

  static List<String> removeComments(List<String> lines) {
    List<String> result = [];
    for (var line in lines) {
      var lineWithoutComments = line.replaceAllMapped(
        RegExp(r'//.*|/\*.*\*/|\".*?\"'),
        (match) {
          if (match.group(0)!.startsWith('"') &&
              match.group(0)!.endsWith('"')) {
            return match.group(0)!;
          } else {
            return '';
          }
        },
      );
      result.add(lineWithoutComments);
    }
    return result;
  }

  static List<String> cleanCode(String scriptContent) {
    // remove comments
    var lines = scriptContent.split('\n');
    var cleanLines = removeComments(lines);

    // remove leading and trailing spaces
    cleanLines = cleanLines.map((line) => line.trim()).toList();

    // remove empty lines
    cleanLines.removeWhere((line) => line.trim().isEmpty);

    return cleanLines;
  }

  static List<String> tokenize(List<String> cleanLines) {
    // ! this implementation is not correct
    List<String> tokens = [];
    for (var line in cleanLines) {
      var lineTokens = line.split(' ');
      for (var token in lineTokens) {
        tokens.add(token);
      }
    }
    return tokens;
  }
}
