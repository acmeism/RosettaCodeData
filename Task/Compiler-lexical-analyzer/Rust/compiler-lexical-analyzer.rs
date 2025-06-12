use once_cell::sync::Lazy;
use std::collections::HashMap;
use std::env;
use std::fmt;
use std::fs;
use std::io::{self, Read, Write};
use std::process;
use std::str;

// =====================================================================================================================
// Errors
// =====================================================================================================================

// Define a custom error type for cleaner error handling
#[derive(Debug)]
enum LexerError {
    Io(io::Error),
    Generic(String),
}

impl fmt::Display for LexerError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            LexerError::Io(e) => write!(f, "I/O Error: {}", e),
            LexerError::Generic(s) => write!(f, "Lexer Error: {}", s),
        }
    }
}

impl std::error::Error for LexerError {}

// Allow easy conversion from io::Error
impl From<io::Error> for LexerError {
    fn from(err: io::Error) -> Self {
        LexerError::Io(err)
    }
}

// Allow easy conversion from String/&str
impl From<String> for LexerError {
    fn from(err: String) -> Self {
        LexerError::Generic(err)
    }
}
impl From<&str> for LexerError {
    fn from(err: &str) -> Self {
        LexerError::Generic(err.to_string())
    }
}

type Result<T> = std::result::Result<T, LexerError>;

// =====================================================================================================================
// Machinery
// =====================================================================================================================

fn file_to_string(path: &str) -> Result<String> {
    fs::read_to_string(path).map_err(LexerError::Io)
}

fn string_to_file(path: &str, contents: &str) -> Result<()> {
    fs::write(path, contents).map_err(LexerError::Io)
}

// Rust version of with_IO, using closures and Result for error handling
fn with_io<F>(source: &str, destination: &str, f: F) -> Result<()>
where
    F: FnOnce(String) -> Result<String>,
{
    let input = if source == "stdin" {
        let mut buffer = String::new();
        io::stdin().read_to_string(&mut buffer)?;
        buffer
    } else {
        file_to_string(source)?
    };

    let output = f(input)?; // Execute the processing function

    if destination == "stdout" {
        print!("{}", output); // Use print! for stdout
        io::stdout().flush()?; // Ensure output is flushed
    } else {
        string_to_file(destination, &output)?;
    }

    Ok(())
}

// Add escaped newlines and backslashes back in for printing
fn sanitize(s: &str) -> String {
    let mut result = String::with_capacity(s.len()); // Pre-allocate
    for c in s.chars() {
        match c {
            '\n' => result.push_str("\\n"),
            '\\' => result.push_str("\\\\"),
            _ => result.push(c),
        }
    }
    result
}

// =====================================================================================================================
// Scanner - Operates on byte slice for closer C++ char* parity
// =====================================================================================================================
#[derive(Debug, Clone, Copy)] // Clone + Copy needed for pre_state
struct Scanner<'a> {
    bytes: &'a [u8],
    pos: usize, // Current byte position
    line: usize,
    column: usize,
}

impl<'a> Scanner<'a> {
    fn new(source: &'a str) -> Self {
        Scanner {
            bytes: source.as_bytes(),
            pos: 0,
            line: 1,
            column: 1,
        }
    }

    // Peek at the current byte without consuming
    fn peek(&self) -> Option<u8> {
        self.bytes.get(self.pos).copied()
    }

    // Peek at the next byte
    fn peek_next(&self) -> Option<u8> {
        self.bytes.get(self.pos + 1).copied()
    }

    // Advance the position by one byte, updating line/column
    fn advance(&mut self) {
        if let Some(byte) = self.peek() {
            self.pos += 1;
            if byte == b'\n' {
                self.line += 1;
                self.column = 1;
            } else {
                self.column += 1;
            }
        }
        // Don't advance past the end
    }

    // Advance and return the *new* current byte
    // Equivalent to C++'s next() behavior: advance then peek
    fn next(&mut self) -> Option<u8> {
        self.advance();
        self.peek()
    }

    // Skip ASCII whitespace characters
    fn skip_whitespace(&mut self) {
        while let Some(byte) = self.peek() {
            if byte.is_ascii_whitespace() {
                self.advance();
            } else {
                break;
            }
        }
    }

    // Get the current byte slice from start_pos to current pos
    fn slice(&self, start_pos: usize) -> &'a [u8] {
        &self.bytes[start_pos..self.pos]
    }
}

// =====================================================================================================================
// Tokens
// =====================================================================================================================
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum TokenName {
    OpMultiply, OpDivide, OpMod, OpAdd, OpSubtract, OpNegate,
    OpLess, OpLessEqual, OpGreater, OpGreaterEqual, OpEqual, OpNotEqual,
    OpNot, OpAssign, OpAnd, OpOr,
    LeftParen, RightParen, LeftBrace, RightBrace, Semicolon, Comma,
    KeywordIf, KeywordElse, KeywordWhile, KeywordPrint, KeywordPutc,
    Identifier, Integer, String,
    EndOfInput, Error,
}

// Use Display trait for string representation
impl fmt::Display for TokenName {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        use TokenName::*;
        let s = match self {
            OpMultiply => "Op_multiply", OpDivide => "Op_divide", OpMod => "Op_mod",
            OpAdd => "Op_add", OpSubtract => "Op_subtract", OpNegate => "Op_negate",
            OpLess => "Op_less", OpLessEqual => "Op_lessequal", OpGreater => "Op_greater",
            OpGreaterEqual => "Op_greaterequal", OpEqual => "Op_equal", OpNotEqual => "Op_notequal",
            OpNot => "Op_not", OpAssign => "Op_assign", OpAnd => "Op_and", OpOr => "Op_or",
            LeftParen => "LeftParen", RightParen => "RightParen", LeftBrace => "LeftBrace",
            RightBrace => "RightBrace", Semicolon => "Semicolon", Comma => "Comma",
            KeywordIf => "Keyword_if", KeywordElse => "Keyword_else", KeywordWhile => "Keyword_while",
            KeywordPrint => "Keyword_print", KeywordPutc => "Keyword_putc",
            Identifier => "Identifier", Integer => "Integer", String => "String",
            EndOfInput => "End_of_input", Error => "Error",
        };
        write!(f, "{}", s)
    }
}

// Rust enum for token values (replaces std::variant)
#[derive(Debug, Clone, PartialEq)]
enum TokenVal {
    Int(i32),
    String(String),
    None, // For tokens without a specific value
}

#[derive(Debug, Clone)]
struct Token {
    name: TokenName,
    value: TokenVal,
    line: usize,
    column: usize,
}

// Use Display trait for formatted token output
impl fmt::Display for Token {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:<2}   {:<2}   ", self.line, self.column)?; // Use Rust formatting for width
        match self.name {
            TokenName::Identifier => {
                if let TokenVal::String(s) = &self.value {
                    write!(f, "{:<18}{}", self.name, s) // Left align with width
                } else {
                    write!(f, "{:<18}<?>", self.name) // Should not happen
                }
            }
            TokenName::Integer => {
                if let TokenVal::Int(i) = &self.value {
                     write!(f, "{:<18}{}", self.name, i)
                } else {
                     write!(f, "{:<18}<?>", self.name)
                }
            }
            TokenName::String => {
                 if let TokenVal::String(s) = &self.value {
                     write!(f, "{:<18}\"{}\"", self.name, sanitize(s))
                 } else {
                     write!(f, "{:<18}<?>", self.name)
                 }
            }
            TokenName::Error => {
                 if let TokenVal::String(s) = &self.value {
                    // Error message might be multi-line, handle indentation carefully
                    let lines: Vec<&str> = s.lines().collect();
                    if lines.is_empty() {
                         write!(f, "{}", self.name)
                    } else {
                         write!(f, "{:<18}{}", self.name, lines[0])?;
                         for line in lines.iter().skip(1) {
                              write!(f, "\n{:<28}{}", "", line)?; // Indent subsequent lines
                         }
                         Ok(()) // Return Ok(()) explicitly as write! doesn't cover all paths
                    }
                 } else {
                      write!(f, "{}", self.name) // Error without details
                 }
            }
            TokenName::EndOfInput => write!(f, "{}", self.name),
            // Default for simple tokens
            _ => write!(f, "{}", self.name),
        }
    }
}


// =====================================================================================================================
// Lexer
// =====================================================================================================================

// Lazy static initialization for the keywords map
static KEYWORDS: Lazy<HashMap<String, TokenName>> = Lazy::new(|| {
    let mut m = HashMap::new();
    m.insert("else".to_string(), TokenName::KeywordElse);
    m.insert("if".to_string(), TokenName::KeywordIf);
    m.insert("print".to_string(), TokenName::KeywordPrint);
    m.insert("putc".to_string(), TokenName::KeywordPutc);
    m.insert("while".to_string(), TokenName::KeywordWhile);
    m
});


struct Lexer<'a> {
    s: Scanner<'a>,
    source: &'a str, // Keep original source for error slicing if needed
                     // pre_state is implicitly captured before each token attempt
}

impl<'a> Lexer<'a> {
    fn new(source: &'a str) -> Self {
        Lexer {
            s: Scanner::new(source),
            source, // Store the source string slice
        }
    }

    // Helper to create a token with current pre-state line/column
    fn make_token(&self, name: TokenName, value: TokenVal, line: usize, column: usize) -> Token {
        Token { name, value, line, column }
    }

    // Helper to create an error token
    fn error_token(&mut self, msg: String, code_snippet: &str, line: usize, column: usize) -> Token {
        let full_msg = format!("{}\n{:>28}({}, {}): {}",
                               msg, "", line, column, code_snippet);

        // Ensure we advance past the problematic character(s) if possible
        // In many cases, advance() might have already happened within the failing logic.
        // If peek is not None, we might advance once more to avoid infinite loops on bad chars.
        if self.s.peek().is_some() {
             // Be cautious here. C++ version advanced unconditionally.
             // Let's only advance if the error didn't consume the char.
             // self.s.advance(); // Maybe remove this, depends on exact error logic
        }

        self.make_token(TokenName::Error, TokenVal::String(full_msg), line, column)
    }

    // Helper for simple single-character tokens
    fn simply(&mut self, name: TokenName, line: usize, column: usize) -> Token {
        self.s.advance();
        self.make_token(name, TokenVal::None, line, column)
    }

    // Helper for tokens like &&, ||
    fn expect(&mut self, expected: u8, name: TokenName, line: usize, column: usize, start_pos: usize) -> Token {
        if self.s.next() == Some(expected) {
            self.s.advance(); // Consume the second character
            self.make_token(name, TokenVal::None, line, column)
        } else {
            // Get the single character that caused the error
            let snippet = str::from_utf8(&self.s.bytes[start_pos..self.s.pos])
                            .unwrap_or("<?>"); // Use slice up to current pos
            let current_char = self.s.peek().map_or('?', |b| b as char); // Use peek for error char
             self.error_token(
                 format!("Unrecognized character '{}' after '{}'", current_char, self.s.bytes[start_pos] as char),
                 snippet,
                 line, // Error occurs at the original line/col
                 column,
             )
        }
    }

    // Helper for tokens like <=, >=, ==, !=
    fn follow(&mut self, expected: u8, ifyes: TokenName, ifno: TokenName, line: usize, column: usize) -> Token {
         if self.s.peek_next() == Some(expected) {
             self.s.advance(); // Consume the first char
             self.s.advance(); // Consume the second char '='
             self.make_token(ifyes, TokenVal::None, line, column)
         } else {
             self.s.advance(); // Consume just the first char
             self.make_token(ifno, TokenVal::None, line, column)
         }
    }

    // Handles / or /* ... */ comments
    fn divide_or_comment(&mut self, line: usize, column: usize, start_pos: usize) -> Token {
        if self.s.peek_next() == Some(b'*') {
            // Start of a block comment
            self.s.advance(); // Consume '/'
            self.s.advance(); // Consume '*'

            loop {
                match self.s.peek() {
                    Some(b'*') => {
                        if self.s.peek_next() == Some(b'/') {
                            self.s.advance(); // Consume '*'
                            self.s.advance(); // Consume '/'
                            return self.next_token(); // Return the *next* token after comment
                        } else {
                            self.s.advance(); // Consume '*' but it wasn't end of comment
                        }
                    }
                    Some(_) => {
                        self.s.advance(); // Consume character inside comment
                    }
                    None => {
                        // Reached EOF inside comment
                        let snippet = str::from_utf8(&self.s.bytes[start_pos..self.s.pos]).unwrap_or("/*...");
                        return self.error_token(
                            "End-of-file in comment. Closing '*/' not found.".to_string(),
                            snippet,
                            line, // Error reported at comment start
                            column,
                        );
                    }
                }
            }
        } else {
            // Just a division operator
            self.s.advance(); // Consume '/'
            self.make_token(TokenName::OpDivide, TokenVal::None, line, column)
        }
    }

     // Handles 'c' character literals -> stored as Integer token
    fn char_lit(&mut self, line: usize, column: usize, start_pos: usize) -> Token {
        self.s.advance(); // Consume opening '

        let char_val = match self.s.peek() {
            None => return self.error_token("End-of-file in char literal.".to_string(), "'", line, column),
            Some(b'\'') => return self.error_token("Empty character constant.".to_string(), "''", line, column),
            Some(b'\\') => { // Escape sequence
                self.s.advance(); // Consume '\'
                match self.s.peek() {
                    Some(b'n') => { self.s.advance(); b'\n' }
                    Some(b'\\') => { self.s.advance(); b'\\' }
                    Some(c) => {
                        let snippet = format!("'\\{}...", c as char);
                         // Advance past the unknown escape char before reporting error
                        self.s.advance();
                        return self.error_token(format!("Unknown escape sequence \\{}", c as char), &snippet, line, column);
                    }
                    None => return self.error_token("End-of-file after escape in char literal.".to_string(), "'\\", line, column),
                }
            }
            Some(byte) => { // Normal character
                self.s.advance();
                byte
            }
        };

        // Check for closing quote
        if self.s.peek() == Some(b'\'') {
            self.s.advance(); // Consume closing '
            self.make_token(TokenName::Integer, TokenVal::Int(char_val as i32), line, column)
        } else {
            // Find the extent of the invalid literal for the error message
            let mut end_pos = self.s.pos;
             while let Some(b) = self.s.bytes.get(end_pos) {
                 if *b == b'\'' || *b == b'\n' || end_pos > start_pos + 10 { // Limit snippet size
                     break;
                 }
                 end_pos += 1;
             }
             // Consume until the closing quote or newline to avoid cascading errors
            while let Some(b) = self.s.peek() {
                 if b == b'\'' { self.s.advance(); break; }
                 if b == b'\n' { break; } // Stop at newline
                 self.s.advance();
             }

            let snippet = str::from_utf8(&self.s.bytes[start_pos..end_pos.min(self.s.bytes.len())])
                            .unwrap_or("<?>");
            self.error_token("Multi-character constant or missing closing quote.".to_string(), snippet, line, column)
        }
    }


    // Handles "..." string literals
    fn string_lit(&mut self, line: usize, column: usize, start_pos: usize) -> Token {
        self.s.advance(); // Consume opening "
        let mut content: Vec<u8> = Vec::new();

        loop {
            match self.s.peek() {
                None => {
                    let snippet = str::from_utf8(&self.s.bytes[start_pos..self.s.pos]).unwrap_or("\"...");
                    return self.error_token("End-of-file while scanning string literal. Closing '\"' not found.".to_string(), snippet, line, column);
                 }
                 Some(b'"') => {
                    self.s.advance(); // Consume closing "
                    // Attempt to convert collected bytes to UTF-8 String
                    match String::from_utf8(content) {
                         Ok(s) => return self.make_token(TokenName::String, TokenVal::String(s), line, column),
                         Err(e) => {
                            let snippet = str::from_utf8(&self.s.bytes[start_pos..self.s.pos]).unwrap_or("<?>");
                             return self.error_token(format!("Invalid UTF-8 sequence in string literal: {}", e), snippet, line, column);
                         }
                    }
                 }
                 Some(b'\n') => {
                     let snippet = str::from_utf8(&self.s.bytes[start_pos..self.s.pos]).unwrap_or("\"...");
                     // Don't consume newline, error points before it
                     return self.error_token("End-of-line while scanning string literal. Closing '\"' not found.".to_string(), snippet, self.s.line, self.s.column); // Report error at current line/col
                 }
                 Some(b'\\') => { // Escape sequence
                     self.s.advance(); // Consume '\'
                     match self.s.peek() {
                         Some(b'n') => { self.s.advance(); content.push(b'\n'); }
                         Some(b'\\') => { self.s.advance(); content.push(b'\\'); }
                         Some(c) => {
                              let snippet = format!("...\\{}...", c as char);
                              // Consume the unknown escape char before reporting error
                              self.s.advance();
                              return self.error_token(format!("Unknown escape sequence \\{}", c as char), &snippet, self.s.line, self.s.column); // Use current line/col
                         }
                         None => {
                             let snippet = str::from_utf8(&self.s.bytes[start_pos..self.s.pos]).unwrap_or("\"...\\");
                             return self.error_token("End-of-file after escape in string literal.".to_string(), snippet, line, column);
                         }
                     }
                 }
                 Some(byte) => { // Normal character
                    content.push(byte);
                    self.s.advance();
                 }
            }
        }
    }

    // Helper predicate functions (using u8 methods)
    #[inline] fn is_id_start(c: u8) -> bool { c.is_ascii_alphabetic() || c == b'_' }
    #[inline] fn is_id_end(c: u8) -> bool { c.is_ascii_alphanumeric() || c == b'_' }
    #[inline] fn is_digit(c: u8) -> bool { c.is_ascii_digit() }

    // Handles identifiers and keywords
    fn identifier(&mut self, line: usize, column: usize, start_pos: usize) -> Token {
        while let Some(byte) = self.s.peek() {
            if Self::is_id_end(byte) {
                self.s.advance();
            } else {
                break;
            }
        }
        let ident_bytes = self.s.slice(start_pos);
        // Identifiers must be valid UTF-8 in Rust
        match str::from_utf8(ident_bytes) {
            Ok(ident_str) => {
                // Check if it's a keyword
                if let Some(keyword_token) = KEYWORDS.get(ident_str) {
                    self.make_token(*keyword_token, TokenVal::None, line, column)
                } else {
                    self.make_token(TokenName::Identifier, TokenVal::String(ident_str.to_string()), line, column)
                }
            }
            Err(_) => {
                // This shouldn't happen if is_id_end checks ASCII, but handle defensively
                self.error_token("Invalid UTF-8 sequence in identifier.".to_string(), "<?>", line, column)
            }
        }
    }


    // Handles integer literals
    fn integer_lit(&mut self, line: usize, column: usize, start_pos: usize) -> Token {
        while let Some(byte) = self.s.peek() {
            if Self::is_digit(byte) {
                self.s.advance();
            } else {
                break;
            }
        }

        // Check if it's followed by an identifier character (invalid number)
         if let Some(byte) = self.s.peek() {
             if Self::is_id_start(byte) {
                 // Consume the invalid part to show in error
                 while let Some(b) = self.s.peek() {
                      if Self::is_id_end(b) { self.s.advance(); } else { break; }
                 }
                 let snippet = str::from_utf8(self.s.slice(start_pos)).unwrap_or("<?>");
                 return self.error_token("Invalid number. Contains non-numeric characters.".to_string(), snippet, line, column);
             }
         }


        let num_bytes = self.s.slice(start_pos);
        match str::from_utf8(num_bytes) {
            Ok(num_str) => {
                match num_str.parse::<i32>() {
                    Ok(n) => self.make_token(TokenName::Integer, TokenVal::Int(n), line, column),
                    Err(e) => {
                        // Could be overflow or other parse error
                        let snippet = str::from_utf8(num_bytes).unwrap_or("<?>");
                        let msg = if e.kind() == &std::num::IntErrorKind::PosOverflow || e.kind() == &std::num::IntErrorKind::NegOverflow {
                            "Number exceeds maximum value.".to_string()
                        } else {
                            format!("Invalid integer literal: {}", e)
                        };
                         self.error_token(msg, snippet, line, column)
                    }
                }
            }
            Err(_) => {
                // Should not happen for digits, but handle defensively
                self.error_token("Invalid UTF-8 sequence in number.".to_string(), "<?>", line, column)
            }
        }
    }

    // Get the next token from the input stream
    pub fn next_token(&mut self) -> Token {
        self.s.skip_whitespace();

        // Capture state *before* processing the token
        let pre_line = self.s.line;
        let pre_column = self.s.column;
        let start_pos = self.s.pos; // Start byte position of the token

        // Use peek() to decide what kind of token comes next
        match self.s.peek() {
            Some(b'*') => self.simply(TokenName::OpMultiply, pre_line, pre_column),
            Some(b'%') => self.simply(TokenName::OpMod, pre_line, pre_column),
            Some(b'+') => self.simply(TokenName::OpAdd, pre_line, pre_column),
            Some(b'-') => self.simply(TokenName::OpSubtract, pre_line, pre_column),
            Some(b'{') => self.simply(TokenName::LeftBrace, pre_line, pre_column),
            Some(b'}') => self.simply(TokenName::RightBrace, pre_line, pre_column),
            Some(b'(') => self.simply(TokenName::LeftParen, pre_line, pre_column),
            Some(b')') => self.simply(TokenName::RightParen, pre_line, pre_column),
            Some(b';') => self.simply(TokenName::Semicolon, pre_line, pre_column),
            Some(b',') => self.simply(TokenName::Comma, pre_line, pre_column),

            Some(b'&') => self.expect(b'&', TokenName::OpAnd, pre_line, pre_column, start_pos),
            Some(b'|') => self.expect(b'|', TokenName::OpOr, pre_line, pre_column, start_pos),

            Some(b'<') => self.follow(b'=', TokenName::OpLessEqual, TokenName::OpLess, pre_line, pre_column),
            Some(b'>') => self.follow(b'=', TokenName::OpGreaterEqual, TokenName::OpGreater, pre_line, pre_column),
            Some(b'=') => self.follow(b'=', TokenName::OpEqual, TokenName::OpAssign, pre_line, pre_column),
            Some(b'!') => self.follow(b'=', TokenName::OpNotEqual, TokenName::OpNot, pre_line, pre_column),

            Some(b'/') => self.divide_or_comment(pre_line, pre_column, start_pos),
            Some(b'\'') => self.char_lit(pre_line, pre_column, start_pos),
            Some(b'"') => self.string_lit(pre_line, pre_column, start_pos),

            Some(c) if Self::is_id_start(c) => self.identifier(pre_line, pre_column, start_pos),
            Some(c) if Self::is_digit(c) => self.integer_lit(pre_line, pre_column, start_pos),

            Some(c) => {
                // Unrecognized character
                let snippet = str::from_utf8(&self.s.bytes[start_pos ..= start_pos]).unwrap_or("?"); // Just the char
                self.s.advance(); // Consume the bad character
                self.error_token(format!("Unrecognized character '{}'", c as char), snippet, pre_line, pre_column)
            }

            None => self.make_token(TokenName::EndOfInput, TokenVal::None, pre_line, pre_column),
        }
    }

    // Check if there are more characters (excluding EOF)
    pub fn has_more(&self) -> bool {
        self.s.peek().is_some()
    }
}

// =====================================================================================================================
// Main Function
// =====================================================================================================================
fn run_lexer(input: String) -> Result<String> {
    let mut lexer = Lexer::new(&input); // Pass input by reference
    let mut output = String::new();

    output.push_str("Location  Token name        Value\n");
    output.push_str("--------------------------------------\n");

    let mut token = lexer.next_token();
    loop {
         output.push_str(&format!("{}\n", token)); // Use the Display impl for Token

         if token.name == TokenName::EndOfInput || token.name == TokenName::Error {
              // If it's an error token, we might stop or continue depending on desired behavior.
              // This version stops on the first error or EOF.
              if token.name == TokenName::Error {
                    // Optionally, return an error instead of just stopping the output string
                    // return Err(LexerError::Generic(format!("Lexing failed at line {}, column {}", token.line, token.column)));
              }
              break;
         }

        token = lexer.next_token();
    }

    Ok(output)
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let in_path = args.get(1).map_or("stdin", |s| s.as_str());
    let out_path = args.get(2).map_or("stdout", |s| s.as_str());

    if let Err(e) = with_io(in_path, out_path, run_lexer) {
        eprintln!("Error: {}", e);
        process::exit(1);
    }
}
