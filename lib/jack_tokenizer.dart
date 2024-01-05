class JackTokenizer {
  String scriptContent;
  int cursor; // index of currentToken's last character
  String? currentToken;

  // What a strange way to write a constructor!
  JackTokenizer(this.scriptContent) : cursor = -1;

  // A core assumption: the scriptContent is a valid Jack script.
  bool hasMoreTokens() {}
}
