using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;


namespace Rosetta {

    public enum TokenType {
        End_of_input, Op_multiply, Op_divide, Op_mod, Op_add, Op_subtract,
        Op_negate, Op_not, Op_less, Op_lessequal, Op_greater, Op_greaterequal,
        Op_equal, Op_notequal, Op_assign, Op_and, Op_or, Keyword_if,
        Keyword_else, Keyword_while, Keyword_print, Keyword_putc, LeftParen, RightParen,
        LeftBrace, RightBrace, Semicolon, Comma, Identifier, Integer, String, None
    }

    /// <summary>
    /// Storage class for tokens
    /// </summary>
    public class Token {
        public TokenType Type { get; set; }
        public int Line { get; set; }
        public int Position { get; set; }
        public string Value { get; set; }
        public override string ToString() {
            if (Type == TokenType.Integer || Type == TokenType.Identifier) {
                return String.Format("{0,-5}  {1,-5}   {2,-14}     {3}", Line, Position, Type.ToString(), Value);
            } else if (Type == TokenType.String) {
                return String.Format("{0,-5}  {1,-5}   {2,-14}     \"{3}\"", Line, Position, Type.ToString(), Value.Replace("\n", "\\n"));
            }
            return String.Format("{0,-5}  {1,-5}   {2,-14}", Line, Position, Type.ToString());
        }
    }

    /// <summary>
    /// C# Example of Lexical scanner for Rosetta Compiler
    /// </summary>
    public class LexicalScanner {

        // character classes
        private const string _letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_";
        private const string _numbers = "0123456789";
        private const string _identifier = _letters + _numbers + "_";
        private const string _whitespace = " \t\n\r";

        // mappings from string keywords to token type
        private Dictionary<string, TokenType> _keywordTokenTypeMap = new Dictionary<string, TokenType>() {
            { "if", TokenType.Keyword_if },
            { "else", TokenType.Keyword_else },
            { "while", TokenType.Keyword_while },
            { "print", TokenType.Keyword_print },
            { "putc", TokenType.Keyword_putc }
        };

        // mappings from simple operators to token type
        private Dictionary<string, TokenType> _operatorTokenTypeMap = new Dictionary<string, TokenType>() {
            { "+", TokenType.Op_add },
            { "-", TokenType.Op_subtract },
            { "*", TokenType.Op_multiply },
            { "/", TokenType.Op_divide },
            { "%", TokenType.Op_mod },
            { "=", TokenType.Op_assign },
            { "<", TokenType.Op_less },
            { ">", TokenType.Op_greater },
            { "!", TokenType.Op_not },
        };

        private List<string> _keywords;
        private string _operators = "+-*/%=<>!%";

        private string _code;
        private List<Token> tokens = new List<Token>();

        private int _line = 1;
        private int _position = 1;

        public string CurrentCharacter {
            get {
                try {
                    return _code.Substring(0, 1);
                } catch (ArgumentOutOfRangeException) {
                    return "";
                }
            }
        }

        /// <summary>
        /// Lexical scanner initialiser
        /// </summary>
        /// <param name="code">Code to be tokenised</param>
        public LexicalScanner (string code) {
            _code = code;
            _keywords = _keywordTokenTypeMap.Keys.ToList();
        }

        /// <summary>
        /// Advance the cursor forward given number of characters
        /// </summary>
        /// <param name="characters">Number of characters to advance</param>
        private void advance(int characters=1) {
            try {
                // reset position when there is a newline
                if (CurrentCharacter == "\n") {
                    _position = 0;
                    _line++;
                }

                _code = _code.Substring(characters, _code.Length - characters);
                _position += characters;
            } catch (ArgumentOutOfRangeException) {
                _code = "";
            }
        }

        /// <summary>
        /// Outputs error message to the console and exits
        /// </summary>
        /// <param name="message">Error message to display to user</param>
        /// <param name="line">Line error occurred on</param>
        /// <param name="position">Line column that the error occurred at</param>
        public void error(string message, int line, int position) {
            // output error to the console and exit
            Console.WriteLine(String.Format("{0} @ {1}:{2}", message, line, position));
            Environment.Exit(1);
        }

        /// <summary>
        /// Pattern matching using first & follow matching
        /// </summary>
        /// <param name="recogniseClass">String of characters that identifies the token type
        /// or the exact match the be made if exact:true</param>
        /// <param name="matchClass">String of characters to match against remaining target characters</param>
        /// <param name="tokenType">Type of token the match represents.</param>
        /// <param name="notNextClass">Optional class of characters that cannot follow the match</param>
        /// <param name="maxLen">Optional maximum length of token value</param>
        /// <param name="exact">Denotes whether recogniseClass represents an exact match or class match.
        /// Default: false</param>
        /// <param name="discard">Denotes whether the token is kept or discarded. Default: false</param>
        /// <param name="offset">Optiona line position offset to account for discarded tokens</param>
        /// <returns>Boolean indicating if a match was made </returns>
        public bool match(string recogniseClass, string matchClass, TokenType tokenType,
                          string notNextClass=null, int maxLen=Int32.MaxValue, bool exact=false,
                          bool discard=false, int offset=0) {

            // if we've hit the end of the file, there's no more matching to be done
            if (CurrentCharacter == "")
                return false;

            // store _current_ line and position so that our vectors point at the start
            // of each token
            int line = _line;
            int position = _position;

            // special case exact tokens to avoid needing to worry about backtracking
            if (exact) {
                if (_code.StartsWith(recogniseClass)) {
                    if (!discard)
                        tokens.Add(new Token() { Type = tokenType, Value = recogniseClass, Line = line, Position = position - offset});
                    advance(recogniseClass.Length);
                    return true;
                }
                return false;
            }

            // first match - denotes the token type usually
            if (!recogniseClass.Contains(CurrentCharacter))
                return false;

            string tokenValue = CurrentCharacter;
            advance();

            // follow match while we haven't exceeded maxLen and there are still characters
            // in the code stream
            while ((matchClass ?? "").Contains(CurrentCharacter) && tokenValue.Length <= maxLen && CurrentCharacter != "") {
                tokenValue += CurrentCharacter;
                advance();
            }

            // ensure that any incompatible characters are not next to the token
            // eg 42fred is invalid, and neither recognized as a number nor an identifier.
            // _letters would be the notNextClass
            if (notNextClass != null && notNextClass.Contains(CurrentCharacter))
                error("Unrecognised character: " + CurrentCharacter, _line, _position);

            // only add tokens to the stack that aren't marked as discard - dont want
            // things like open and close quotes/comments
            if (!discard) {
                Token token = new Token() { Type = tokenType, Value = tokenValue, Line = line, Position = position - offset };
                tokens.Add(token);
            }

            return true;
        }

        /// <summary>
        /// Tokenise the input code
        /// </summary>
        /// <returns>List of Tokens</returns>
        public List<Token> scan() {

            while (CurrentCharacter != "") {
                // match whitespace
                match(_whitespace, _whitespace, TokenType.None, discard: true);

                // match integers
                match(_numbers, _numbers, TokenType.Integer, notNextClass:_letters);

                // match identifiers and keywords
                if (match(_letters, _identifier, TokenType.Identifier)) {
                    Token match = tokens.Last();
                    if (_keywords.Contains(match.Value))
                        match.Type = _keywordTokenTypeMap[match.Value];
                }

                // match string similarly to comments without allowing newlines
                // this token doesn't get discarded though
                if (match("\"", null, TokenType.String, discard:true)) {
                    string value = "";
                    int position = _position;
                    while (!match("\"", null, TokenType.String, discard:true)) {
                        // not allowed newlines in strings
                        if (CurrentCharacter == "\n")
                            error("End-of-line while scanning string literal. Closing string character not found before end-of-line", _line, _position);
                        // end of file reached before finding end of string
                        if (CurrentCharacter == "")
                            error("End-of-file while scanning string literal. Closing string character not found", _line, _position);

                        value += CurrentCharacter;

                        // deal with escape sequences - we only accept newline (\n)
                        if (value.Length >= 2) {
                            string lastCharacters = value.Substring(value.Length - 2, 2);
                            if (lastCharacters[0] == '\\') {
                                if (lastCharacters[1] != 'n') {
                                    error("Unknown escape sequence. ", _line, position);
                                }
                                value = value.Substring(0, value.Length - 2).ToString() + "\n";
                            }
                        }

                        advance();
                    }
                    tokens.Add(new Token() { Type = TokenType.String, Value = value, Line = _line, Position = position - 1});
                }

                // match string literals
                if (match("'", null, TokenType.Integer, discard:true)) {
                    int value;
                    int position = _position;
                    value = CurrentCharacter.ToCharArray()[0];
                    advance();

                    // deal with empty literals ''
                    if (value == '\'')
                        error("Empty character literal", _line, _position);

                    // deal with escaped characters, only need to worry about \n and \\
                    // throw werror on any other
                    if (value == '\\') {
                        if (CurrentCharacter == "n") {
                            value = '\n';
                        } else if (CurrentCharacter == "\\") {
                            value = '\\';
                        } else {
                            error("Unknown escape sequence. ", _line, _position - 1);
                        }
                        advance();
                    }

                    // if we haven't hit a closing ' here, there are two many characters
                    // in the literal
                    if (!match("'", null, TokenType.Integer, discard: true))
                        error("Multi-character constant", _line, _position);

                    tokens.Add(new Rosetta.Token() { Type = TokenType.Integer, Value = value.ToString(), Line = _line, Position = position - 1 });
                }

                // match comments by checking for starting token, then advancing
                // until closing token is matched
                if (match("/*", null, TokenType.None, exact: true, discard: true)) {
                    while (!match("*/", null, TokenType.None, exact: true, discard: true)) {
                        // reached the end of the file without closing comment!
                        if (CurrentCharacter == "")
                            error("End-of-file in comment. Closing comment characters not found.", _line, _position);
                        advance();
                    }
                    continue;
                }

                // match complex operators
                match("<=", null, TokenType.Op_lessequal, exact: true);
                match(">=", null, TokenType.Op_greaterequal, exact: true);
                match("==", null, TokenType.Op_equal, exact: true);
                match("!=", null, TokenType.Op_notequal, exact: true);
                match("&&", null, TokenType.Op_and, exact: true);
                match("||", null, TokenType.Op_or, exact: true);

                // match simple operators
                if (match(_operators, null, TokenType.None, maxLen:1)) {
                    Token match = tokens.Last();
                    match.Type = _operatorTokenTypeMap[match.Value];
                }

                // brackets, braces and separators
                match("(", null, TokenType.LeftParen, exact: true);
                match(")", null, TokenType.RightParen, exact: true);
                match("{", null, TokenType.LeftBrace, exact: true);
                match("}", null, TokenType.RightBrace, exact: true);
                match(";", null, TokenType.Semicolon, exact: true);
                match(",", null, TokenType.Comma, exact: true);

            }

            // end of file token
            tokens.Add(new Rosetta.Token() { Type = TokenType.End_of_input, Line = _line, Position = _position });

            return tokens;
        }

        static void Main (string[] args) {
            StreamReader inputFile;

            // if we passed in a filename, read code from that, else
            // read code from stdin
            if (args.Length > 0) {
                string path = args[0];
                try {
                    inputFile = new StreamReader(path);
                } catch (IOException) {
                    inputFile = new StreamReader(Console.OpenStandardInput(8192));
                }
            } else {
                inputFile = new StreamReader(Console.OpenStandardInput(8192));
            }

            string code = inputFile.ReadToEnd();

            // strip windows line endings out
            code = code.Replace("\r", "");

            LexicalScanner scanner = new LexicalScanner(code);
            List<Token> tokens = scanner.scan();

            foreach(Token token in tokens) {
                Console.WriteLine(token.ToString());
            }
        }
    }
}
