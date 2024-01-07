enum CommentType {
  doubleSlash, // // comment \n
  slashStar, // /* comment */ or /** comment */
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
          tmpCursor++;
          String nextChar = scriptContent[tmpCursor];
          if (nextChar == '/') {
            while (scriptContent[tmpCursor] != '\n') {
              tmpCursor++;
              if (tmpCursor >= scriptContent.length) {
                return false;
              }
            }
          } else if (nextChar == '*') {
            // This case would be invalid Jack script:
            //    An open /* without closing */
            // It would not happen to this project because
            // we assume all jack files are valid
            if (tmpCursor + 2 >= scriptContent.length) {
              return false;
            }

            String possibleEndComment =
                scriptContent[tmpCursor + 1] + scriptContent[tmpCursor + 2];

            while (possibleEndComment != '*/') {
              tmpCursor++;
              if (tmpCursor + 2 >= scriptContent.length) {
                return false;
              }
              possibleEndComment =
                  scriptContent[tmpCursor + 1] + scriptContent[tmpCursor + 2];
            }
          } else {
            // I don't think we will reach here
            throw Exception("Invalid comment");
          }
        } else {
          // if it is not a whitespace, newline and comment
          // then it is a valid token, because we assume the script is valid
          return true;
        }
      }
    }
  }
}

/**
 * Possible way to get next token:
 *   - get the first valid character
 *   - if it is a comment, then continue to the end of the comment. 
 *   -    try to find a valid token after the comment
 *   - if it is a string, then continue to the end of the string. Return True.
 *   - if it is a normal character, then do following check
 *      - if it is a symbol, then return True
 *      - else continue till the end of the token. Return True.
 * 
 * hasMoreTokens():
 *    - get the first valid character, it should not be whitespace or newline
 *    - if it is a comment, then continue to the end of the comment. 
 *       - then start again
 *    - else it is definitely true
 */
