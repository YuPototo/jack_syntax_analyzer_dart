enum CommentType {
  doubleSlash, // // comment \n
  slashStar, // /* comment */ or /** comment */
}

enum TokenType {
  keyword,
  symbol,
  identifier,
  intConstant,
  stringConstant,
}

class JackTokenizer {
  String scriptContent;
  int cursor; // index of currentToken's last character
  String? currentToken;

  // What a strange way to write a constructor!
  JackTokenizer(this.scriptContent) : cursor = -1;

  // A core assumption: the scriptContent is a valid Jack script.
  bool hasMoreTokens() {
    if (cursor + 1 >= scriptContent.length) {
      return false;
    }

    // use tmpCursor because we don't want to change the cursor here
    int tmpCursor = cursor;

    String possibleToken = "";
    // get next character
    bool getMoreCharacter = true;

    while (getMoreCharacter) {
      tmpCursor++;

      if (tmpCursor >= scriptContent.length) {
        return false;
      }

      String newChar = scriptContent[tmpCursor];

      // identify the first valid character
      if (possibleToken.isEmpty) {
        // ignore whitespace and newlines
        if (newChar == " " || newChar == "\n") {
          continue;
        } else if (newChar == '/') {
          tmpCursor = JackTokenizer.handleComment(scriptContent, tmpCursor);
        } else {
          // if it is not a whitespace, newline and comment
          // then it is a valid token, because we assume the script is valid
          return true;
        }
      }
    }
  }

  // Should be called only if `hasMoreTokens` is true.
  void advance() {
    String possibleToken = "";
    // get next character
    bool getMoreCharacter = true;

    final RegExp symbolRegex = RegExp(r"[\(\);{}\[\]\.,\+\-\*/&\|<>=~]");

    while (getMoreCharacter) {
      cursor++;

      if (cursor >= scriptContent.length) {
        currentToken = possibleToken;
        getMoreCharacter = false;
        break;
      }

      String newChar = scriptContent[cursor];

      // identify the first valid character
      if (possibleToken.isEmpty) {
        if (newChar == " " || newChar == "\n") {
          continue;
        } else if (newChar == '/') {
          int endCommentCursor =
              JackTokenizer.handleComment(scriptContent, cursor);
          cursor = endCommentCursor;
        } else if (newChar == '"') {
          handleStringConstant();
          getMoreCharacter = false;

          break;
        } else {
          if (symbolRegex.hasMatch(newChar)) {
            currentToken = newChar;
            getMoreCharacter = false;
            break;
          } else {
            possibleToken += newChar;
          }
        }
      } else {
        if (newChar == " " || newChar == "\n") {
          getMoreCharacter = false;
          currentToken = possibleToken;
        } else {
          if (symbolRegex.hasMatch(newChar)) {
            cursor--;
            currentToken = possibleToken;
            getMoreCharacter = false;
            break;
          } else {
            possibleToken += newChar;
          }
        }
      }
    }
  }

  /// return the cursor after the comment
  /// when calling this function, the cursor should be at the first /
  static int handleComment(String script, int cursor) {
    int cursorCopy = cursor;

    var firstChar = script[cursorCopy];

    if (firstChar != '/') {
      throw Exception("Invalid comment");
    }

    var firstTwoChar = script[cursorCopy] + script[cursorCopy + 1];

    if (firstTwoChar == '//') {
      while (script[cursorCopy] != '\n') {
        cursorCopy++;
      }
      return cursorCopy;
    } else if (firstTwoChar == '/*') {
      while (script[cursorCopy + 1] + script[cursorCopy + 2] != '*/') {
        cursorCopy++;
      }
      return cursorCopy + 2;
    } else {
      throw Exception("Invalid comment");
    }
  }

  /// set cursor to the end of string constant
  /// set currentToken to the string with double quotes
  void handleStringConstant() {
    var firstChar = scriptContent[cursor];

    if (firstChar != '"') {
      throw Exception("Invalid string constant");
    }
    String stringConstant = '"';

    cursor++;

    while (scriptContent[cursor] != '"') {
      stringConstant += scriptContent[cursor];
      cursor++;
    }

    stringConstant += '"';
    currentToken = stringConstant;
  }
}

/**
 * advance():
 *   - get the first valid character. There are 4 cases:
 *      1. whitespace or newline
 *      2. comment: continue to the end of the comment 
 *      3. string: continue to the end of the string
 *      4. non-string token: handle the token 
 *   - Case 1: whitespace or newline. ignore it and continue to the next character
 *   - Case 2: comment. continue to the end of the comment. Then start again.
 *   - Case 3: string. continue to the end of the string. Set currentToken to the string.
 *   - Case 4: non-string token. Handle it and set currentToken to the token.
 * 
 * hasMoreTokens():
 *    - get the first valid character
 *    - if it is a whitespace or newline, then continue to the next character
 *    - if it is a comment, then continue to the end of the comment. 
 *       - then start again
 *    - else it is definitely true, because we assume the script is valid
 */
