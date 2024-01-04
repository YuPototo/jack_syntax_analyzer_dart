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
    List<String> tokens = [];
    for (var line in cleanLines) {
      var newTokens = tokenizeLine(line);
      tokens.addAll(newTokens);
    }
    return tokens;
  }

  static List<String> handleTokenWithSign(String possibleTokens) {
    List<String> tokens = [];
    if (possibleTokens.endsWith(';')) {
      var firstPart = possibleTokens.substring(0, possibleTokens.length - 1);
      if (firstPart != '') {
        tokens.addAll(handleTokenWithSign(firstPart));
      }
      tokens.add(';');
    } else if (possibleTokens.startsWith('(')) {
      tokens.add('(');
      var afterParenthesis = possibleTokens.substring(1);
      if (afterParenthesis != '') {
        tokens.add(afterParenthesis);
      }
    } else if (possibleTokens.endsWith(')')) {
      var beforeParenthesis =
          possibleTokens.substring(0, possibleTokens.length - 1);
      if (beforeParenthesis != '') {
        tokens.add(beforeParenthesis);
      }
      tokens.add(')');
    } else if (possibleTokens.endsWith(',')) {
      var beforeComma = possibleTokens.substring(0, possibleTokens.length - 1);
      if (beforeComma != '') {
        tokens.add(beforeComma);
      }
      tokens.add(',');
    } else {
      tokens.add(possibleTokens);
    }
    return tokens;
  }

  static List<String> tokenizeLine(String cleanLine) {
    List<String> tokens = [];

    for (var word in cleanLine.split(' ')) {
      if (word.contains(RegExp(r'[;(),]'))) {
        tokens.addAll(handleTokenWithSign(word));
      } else {
        tokens.add(word);
      }
    }
    return tokens;
  }
}
