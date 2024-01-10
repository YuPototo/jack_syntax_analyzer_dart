# Jack Syntax Analyzer

Nand2Tetris project 10: Jack Syntax Analyzer.

## Usage

```bash
dart bin/main.dart <input-path>
```

Input path can be a file or a directory. If it is a directory, all files with the extension `.jack` will be processed.

One or many `.xml` files will be generated in the same directory as the input file(s). The files represent the structured representation of the input source code wrapped in XML tags.

## Assumption

- The input file is a valid Jack file.

## Example

Input file:

```jack
while (count < 100) {
    let count = count + 1;
}
```

Output file:

```xml
<whileStatement>
    <keyword> while </keyword>
    <symbol> ( </symbol>
    <expression>
        <term>
            <varName>count</varName>            
        </term>
        <op><symbol>&lt;</symbol></op>
        <term>
            <constant>100</constant>
        </term>
    </expression>
    <symbol> ) </symbol>
    <symbol> { </symbol>
    <statements>
        <letStatement>
            <keyword> let </keyword>
            <varName>count</varName>
            <symbol> = </symbol>
            <expression>
                <term>
                    <varName>count</varName>
                </term>
                <op><symbol>+</symbol></op>
                <term>
                    <constant>1</constant>
                </term>
            </expression>
            <symbol> ; </symbol>
        </letStatement>
    </statements>
    <symbol> } </symbol>

</whileStatement>
```

## Modules

- Tokenizer: This module is responsible for tokenizing the input file.
- CompilationEngine: This module emits a structured representation of the input source code wrapped in XML tags.

## Tokenizer

### Token Types

- Keyword
- Symbol
- Identifier
- Integer Constant
- String Constant

Ref: Figure 10.5

### String Constant

The program ignores the double quotes in string constants.

### Special Symbol

Four special symbols are escaped in XML:

- `<` -> `&lt;`
- `>` -> `&gt;`
- `"` -> `&quot;`
- `&` -> `&amp;`

### Tokenizer API

- `constructor`: Takes string as input and initializes the tokenizer.
- `hasMoreTokens`: Returns true if there are more tokens available.
- `advance`: Reads the next token from the input and makes it the current token. Should be called only if `hasMoreTokens` is true.
- `tokenType`: Returns the type of the current token.
- `keyword`: Returns the keyword which is the current token. Should be called only if `tokenType` is `KEYWORD`.
- `symbol`: Returns the character which is the current token. Should be called only if `tokenType` is `SYMBOL`.
- `identifier`: Returns the identifier which is the current token. Should be called only if `tokenType` is `IDENTIFIER`.
- `intVal`: Returns the integer value of the current token. Should be called only if `tokenType` is `INT_CONST`.
- `stringVal`: Returns the string value of the current token, without the double quotes. Should be called only if `tokenType` is `STRING_CONST`.

## Compilation Engine

Parse the input file and generate the structured representation of the input source code wrapped in XML tags.

Expressions and array-oriented commands are ignored.

### Compilation Engine API

- `constructor`: Takes string as input and initializes the compilation engine.
- `compileClass`: Compiles a complete class.
- `compileClassVarDec`: Compiles a static declaration or a field declaration.
- `compileSubroutine`: Compiles a complete method, function, or constructor.
- `compileParameterList`: Compiles a (possibly empty) parameter list, not including the enclosing “()”. 
- `compileVarDec`: Compiles a var declaration.
- `compileStatements`: Compiles a sequence of statements, not including the enclosing “{}”.
- `compileLet`: Compiles a let statement.
- `compileIf`: Compiles an if statement, possibly with a trailing else clause.
- `compileWhile`: Compiles a while statement.
- `compileDo`: Compiles a do statement.
- `compileReturn`: Compiles a return statement.
- `compileExpression`: Compiles an expression.
- `compileTerm`: Compiles a term. If the current token is an identifier, the routine must distinguish between a variable, an array entry, and a subroutine call.
- `compileExpressionList`: Compiles a (possibly empty) comma-separated list of expressions.
