// src/main.rs

use std::env;
use std::fs::File;
use std::io::{self, prelude::*, BufReader, BufWriter, Lines};
use std::process::exit;
use std::collections::HashMap; // For potentially faster token lookup if needed

// --- Enums ---

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)] // Added Hash for HashMap key
pub enum TokenType {
    Eoi, Mul, Div, Mod, Add, Sub, Negate, Not, Lss, Leq, Gtr,
    Geq, Eql, Neq, Assign, And, Or, If, Else, While, Print,
    Putc, Lparen, Rparen, Lbrace, Rbrace, Semi, Comma, Ident,
    Integer, String,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum NodeType {
    Ident, String, Integer, Sequence, If, Prtc, Prts, Prti, While,
    Assign, Negate, Not, Mul, Div, Mod, Add, Sub, Lss, Leq,
    Gtr, Geq, Eql, Neq, And, Or,
}

// --- Structs ---

#[derive(Debug, Clone)]
pub struct Token {
    tok_type: TokenType,
    err_ln: usize,
    err_col: usize,
    text: Option<String>, // Use Option<String> for optional text
}

#[derive(Debug, Clone)]
pub struct AstNode {
    node_type: NodeType,
    // Use Option<Box<T>> for optional, heap-allocated children
    left: Option<Box<AstNode>>,
    right: Option<Box<AstNode>>,
    // Use Option<String> for optional value (ident, literal)
    value: Option<String>,
}

#[derive(Debug)]
pub struct TokenAttributes {
    text: &'static str,
    enum_text: &'static str,
    tok_type: TokenType,
    right_associative: bool,
    is_binary: bool,
    is_unary: bool,
    precedence: Option<u8>, // Use Option for precedence (-1 in C)
    node_type: Option<NodeType>, // Use Option for node type (-1 in C)
}

// --- Static Data ---

// Use 'static lifetime for compile-time constants
// Order MUST match TokenType enum definition
const TOKEN_ATTRIBUTES: &[TokenAttributes] = &[
    TokenAttributes { text: "EOI", enum_text: "End_of_input", tok_type: TokenType::Eoi, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: None },
    TokenAttributes { text: "*", enum_text: "Op_multiply", tok_type: TokenType::Mul, right_associative: false, is_binary: true, is_unary: false, precedence: Some(13), node_type: Some(NodeType::Mul) },
    TokenAttributes { text: "/", enum_text: "Op_divide", tok_type: TokenType::Div, right_associative: false, is_binary: true, is_unary: false, precedence: Some(13), node_type: Some(NodeType::Div) },
    TokenAttributes { text: "%", enum_text: "Op_mod", tok_type: TokenType::Mod, right_associative: false, is_binary: true, is_unary: false, precedence: Some(13), node_type: Some(NodeType::Mod) },
    TokenAttributes { text: "+", enum_text: "Op_add", tok_type: TokenType::Add, right_associative: false, is_binary: true, is_unary: false, precedence: Some(12), node_type: Some(NodeType::Add) },
    TokenAttributes { text: "-", enum_text: "Op_subtract", tok_type: TokenType::Sub, right_associative: false, is_binary: true, is_unary: false, precedence: Some(12), node_type: Some(NodeType::Sub) },
    TokenAttributes { text: "-", enum_text: "Op_negate", tok_type: TokenType::Negate, right_associative: false, is_binary: false, is_unary: true, precedence: Some(14), node_type: Some(NodeType::Negate) }, // NOTE: C code listed Sub/Add precedence here, but Negate makes more sense
    TokenAttributes { text: "!", enum_text: "Op_not", tok_type: TokenType::Not, right_associative: false, is_binary: false, is_unary: true, precedence: Some(14), node_type: Some(NodeType::Not) },
    TokenAttributes { text: "<", enum_text: "Op_less", tok_type: TokenType::Lss, right_associative: false, is_binary: true, is_unary: false, precedence: Some(10), node_type: Some(NodeType::Lss) },
    TokenAttributes { text: "<=", enum_text: "Op_lessequal", tok_type: TokenType::Leq, right_associative: false, is_binary: true, is_unary: false, precedence: Some(10), node_type: Some(NodeType::Leq) },
    TokenAttributes { text: ">", enum_text: "Op_greater", tok_type: TokenType::Gtr, right_associative: false, is_binary: true, is_unary: false, precedence: Some(10), node_type: Some(NodeType::Gtr) },
    TokenAttributes { text: ">=", enum_text: "Op_greaterequal", tok_type: TokenType::Geq, right_associative: false, is_binary: true, is_unary: false, precedence: Some(10), node_type: Some(NodeType::Geq) },
    TokenAttributes { text: "==", enum_text: "Op_equal", tok_type: TokenType::Eql, right_associative: false, is_binary: true, is_unary: false, precedence: Some(9), node_type: Some(NodeType::Eql) },
    TokenAttributes { text: "!=", enum_text: "Op_notequal", tok_type: TokenType::Neq, right_associative: false, is_binary: true, is_unary: false, precedence: Some(9), node_type: Some(NodeType::Neq) },
    TokenAttributes { text: "=", enum_text: "Op_assign", tok_type: TokenType::Assign, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: Some(NodeType::Assign) }, // Assignment is special, not a standard binary op in expr parsing
    TokenAttributes { text: "&&", enum_text: "Op_and", tok_type: TokenType::And, right_associative: false, is_binary: true, is_unary: false, precedence: Some(5), node_type: Some(NodeType::And) },
    TokenAttributes { text: "||", enum_text: "Op_or", tok_type: TokenType::Or, right_associative: false, is_binary: true, is_unary: false, precedence: Some(4), node_type: Some(NodeType::Or) },
    TokenAttributes { text: "if", enum_text: "Keyword_if", tok_type: TokenType::If, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: Some(NodeType::If) },
    TokenAttributes { text: "else", enum_text: "Keyword_else", tok_type: TokenType::Else, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: None },
    TokenAttributes { text: "while", enum_text: "Keyword_while", tok_type: TokenType::While, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: Some(NodeType::While) },
    TokenAttributes { text: "print", enum_text: "Keyword_print", tok_type: TokenType::Print, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: None },
    TokenAttributes { text: "putc", enum_text: "Keyword_putc", tok_type: TokenType::Putc, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: None },
    TokenAttributes { text: "(", enum_text: "LeftParen", tok_type: TokenType::Lparen, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: None },
    TokenAttributes { text: ")", enum_text: "RightParen", tok_type: TokenType::Rparen, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: None },
    TokenAttributes { text: "{", enum_text: "LeftBrace", tok_type: TokenType::Lbrace, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: None },
    TokenAttributes { text: "}", enum_text: "RightBrace", tok_type: TokenType::Rbrace, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: None },
    TokenAttributes { text: ";", enum_text: "Semicolon", tok_type: TokenType::Semi, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: None },
    TokenAttributes { text: ",", enum_text: "Comma", tok_type: TokenType::Comma, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: None },
    TokenAttributes { text: "Ident", enum_text: "Identifier", tok_type: TokenType::Ident, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: Some(NodeType::Ident) },
    TokenAttributes { text: "Integer literal", enum_text: "Integer", tok_type: TokenType::Integer, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: Some(NodeType::Integer) },
    TokenAttributes { text: "String literal", enum_text: "String", tok_type: TokenType::String, right_associative: false, is_binary: false, is_unary: false, precedence: None, node_type: Some(NodeType::String) },
];

// Create a lazy-initialized HashMap for faster lookup by enum_text
use lazy_static::lazy_static; // Add `lazy_static = "1.4.0"` to Cargo.toml
lazy_static! {
    static ref TOKEN_MAP_BY_ENUM_TEXT: HashMap<&'static str, &'static TokenAttributes> = {
        let mut m = HashMap::new();
        for attr in TOKEN_ATTRIBUTES {
            m.insert(attr.enum_text, attr);
        }
        m
    };
    static ref TOKEN_MAP_BY_TYPE: HashMap<TokenType, &'static TokenAttributes> = {
         let mut m = HashMap::new();
        for attr in TOKEN_ATTRIBUTES {
            m.insert(attr.tok_type, attr);
        }
        m
    };
}


const DISPLAY_NODES: &[&str] = &[
    "Identifier", "String", "Integer", "Sequence", "If", "Prtc",
    "Prts", "Prti", "While", "Assign", "Negate", "Not", "Multiply", "Divide", "Mod",
    "Add", "Subtract", "Less", "LessEqual", "Greater", "GreaterEqual", "Equal",
    "NotEqual", "And", "Or",
];

// --- Error Handling ---

#[derive(Debug)]
pub enum ParseError {
    Io(io::Error),
    UnexpectedToken {
        expected: String, // Can describe expected category or specific token
        found: Token,
        context: &'static str,
    },
    InvalidTokenFormat(usize, String), // line_num, line_content
    UnknownTokenName(String),
    EndOfInput,
    Custom(String),
}

// Allow converting io::Error into ParseError
impl From<io::Error> for ParseError {
    fn from(err: io::Error) -> Self {
        ParseError::Io(err)
    }
}

impl std::fmt::Display for ParseError {
     fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ParseError::Io(err) => write!(f, "I/O Error: {}", err),
            ParseError::UnexpectedToken { expected, found, context } => {
                let found_attr = TOKEN_MAP_BY_TYPE.get(&found.tok_type).map_or("?", |a| a.text);
                 write!(
                    f,
                    "({}, {}) Parse Error in {}: Expected {}, found '{}' ({:?})",
                    found.err_ln, found.err_col, context, expected, found_attr, found.tok_type
                )
            }
            ParseError::InvalidTokenFormat(line_num, line) => {
                 write!(f, "Invalid token format on line {}: '{}'", line_num, line)
            }
            ParseError::UnknownTokenName(name) => write!(f, "Unknown token name: {}", name),
            ParseError::EndOfInput => write!(f, "Unexpected end of input"),
            ParseError::Custom(msg) => write!(f, "Error: {}", msg),
        }
    }
}

impl std::error::Error for ParseError {}

type ParseResult<T> = Result<T, ParseError>;

// --- Helper Functions ---

fn get_token_attr(token_type: TokenType) -> &'static TokenAttributes {
    // Using HashMap lookup now
    TOKEN_MAP_BY_TYPE.get(&token_type)
        .unwrap_or_else(|| panic!("Internal error: Missing attributes for token type {:?}", token_type)) // Should not happen if maps are correct
}

fn make_node(node_type: NodeType, left: Option<Box<AstNode>>, right: Option<Box<AstNode>>) -> Box<AstNode> {
    Box::new(AstNode {
        node_type,
        left,
        right,
        value: None,
    })
}

fn make_leaf(node_type: NodeType, value: String) -> Box<AstNode> {
    Box::new(AstNode {
        node_type,
        left: None,
        right: None,
        value: Some(value),
    })
}


// --- Parser Struct ---

struct Parser<R: BufRead> {
    // Use Lines iterator for easy line reading
    lines: Lines<R>,
    current_line_num: usize,
    // Store the *next* token to be processed (lookahead)
    current_token: Token,
}

impl<R: BufRead> Parser<R> {
    fn new(reader: R) -> ParseResult<Self> {
        let mut parser = Parser {
            lines: reader.lines(),
            current_line_num: 0,
            // Initialize with a dummy EOI token before the first read
            current_token: Token {
                tok_type: TokenType::Eoi,
                err_ln: 0,
                err_col: 0,
                text: None,
            },
        };
        // Read the first actual token
        parser.next_token()?;
        Ok(parser)
    }

    // Reads the next line and parses it into a token, updating self.current_token
    fn next_token(&mut self) -> ParseResult<()> {
        match self.lines.next() {
            Some(Ok(line)) => {
                self.current_line_num += 1;
                let trimmed_line = line.trim_end(); // Keep original line for error msg
                if trimmed_line.is_empty() {
                    // Skip empty lines potentially introduced by trimming or blank lines
                    return self.next_token();
                }

                let mut parts = trimmed_line.splitn(4, |c: char| c.is_whitespace());

                let err_ln_str = parts.next();
                let err_col_str = parts.next();
                let name_str = parts.next();
                let remaining = parts.next().unwrap_or("").trim_start(); // Rest of the line is optional value


                // Use if let for cleaner parsing and error handling
                if let (Some(ln_s), Some(col_s), Some(name)) = (err_ln_str, err_col_str, name_str) {
                     let err_ln = ln_s.parse::<usize>()
                        .map_err(|_| ParseError::InvalidTokenFormat(self.current_line_num, line.clone()))?;
                    let err_col = col_s.parse::<usize>()
                        .map_err(|_| ParseError::InvalidTokenFormat(self.current_line_num, line.clone()))?;

                    // Lookup token type from name
                    let attributes = TOKEN_MAP_BY_ENUM_TEXT.get(name)
                        .ok_or_else(|| ParseError::UnknownTokenName(name.to_string()))?;

                    let text = if !remaining.is_empty() {
                        Some(remaining.to_string())
                    } else {
                        None
                    };

                    self.current_token = Token {
                        tok_type: attributes.tok_type,
                        err_ln,
                        err_col,
                        text,
                    };
                    Ok(())

                } else {
                     Err(ParseError::InvalidTokenFormat(self.current_line_num, line))
                }
            }
            Some(Err(e)) => Err(ParseError::Io(e)),
            None => {
                // End of input, set token to EOI
                self.current_token = Token {
                    tok_type: TokenType::Eoi,
                    // Use last known line/col or defaults if file was empty
                    err_ln: self.current_token.err_ln,
                    err_col: self.current_token.err_col,
                    text: None,
                };
                Ok(())
            }
        }
    }

    // Check current token type, consume it if it matches, otherwise return error
    fn expect(&mut self, expected: TokenType, context: &'static str) -> ParseResult<()> {
        if self.current_token.tok_type == expected {
            self.next_token()?;
            Ok(())
        } else {
            Err(ParseError::UnexpectedToken {
                expected: format!("'{}' ({:?})", get_token_attr(expected).text, expected),
                found: self.current_token.clone(), // Clone token for error reporting
                context,
            })
        }
    }

    // Check current token type *without* consuming it
    fn check(&self, expected: TokenType) -> bool {
         self.current_token.tok_type == expected
    }

     // Get the current token's text value, expecting it to exist
    fn consume_text(&mut self, context: &'static str) -> ParseResult<String> {
        let token = self.current_token.clone(); // Clone before consuming
        let text = token.text.ok_or_else(|| ParseError::Custom(
             format!("({},{}) Expected text value for token {:?} in {}",
                 token.err_ln, token.err_col, token.tok_type, context)
        ))?;
        self.next_token()?; // Consume the token
        Ok(text)
    }


    // --- Parsing Methods (Expression & Statement) ---

    // expr: Parse expressions using precedence climbing
    fn expr(&mut self, min_precedence: u8) -> ParseResult<Box<AstNode>> {
        let mut left = self.parse_primary()?;

        // Precedence climbing loop
        loop {
            let current_tok_type = self.current_token.tok_type;
            let current_attr = get_token_attr(current_tok_type);

            // Stop if token is not a binary operator OR its precedence is too low
             if !current_attr.is_binary || current_attr.precedence.unwrap_or(0) < min_precedence {
                 break;
             }

            let op_type = current_tok_type;
            let precedence = current_attr.precedence.unwrap(); // Known because is_binary is true
            let node_type = current_attr.node_type.expect("Binary operator must have node type");

            // Consume operator token
            self.next_token()?;

            // Determine precedence for recursive call (handle associativity)
            let next_min_precedence = if current_attr.right_associative {
                precedence
            } else {
                precedence + 1
            };

            let right = self.expr(next_min_precedence)?;
            left = make_node(node_type, Some(left), Some(right));
        }

        Ok(left)
    }

    // Parse primary expressions (literals, identifiers, unary ops, parentheses)
    fn parse_primary(&mut self) -> ParseResult<Box<AstNode>> {
        let token = self.current_token.clone(); // Clone token info before consuming

        match token.tok_type {
            TokenType::Lparen => self.paren_expr(),
            TokenType::Sub | TokenType::Add => { // Unary +/-
                self.next_token()?; // Consume '-' or '+'
                let node = self.expr(get_token_attr(TokenType::Negate).precedence.unwrap())?; // Use Negate's precedence
                if token.tok_type == TokenType::Sub {
                     Ok(make_node(NodeType::Negate, Some(node), None))
                } else {
                     Ok(node) // Unary plus is identity
                }
            }
            TokenType::Not => { // Unary !
                 self.next_token()?; // Consume '!'
                 let node = self.expr(get_token_attr(TokenType::Not).precedence.unwrap())?;
                 Ok(make_node(NodeType::Not, Some(node), None))
            }
            TokenType::Ident => {
                let ident_name = self.consume_text("identifier")?;
                Ok(make_leaf(NodeType::Ident, ident_name))
            }
            TokenType::Integer => {
                let int_val = self.consume_text("integer literal")?;
                Ok(make_leaf(NodeType::Integer, int_val))
             }
             // String literals only appear in 'print' in this grammar?
             // If they could be primary expressions, add:
             // TokenType::String => {
             //    let str_val = self.consume_text("string literal")?;
             //    Ok(make_leaf(NodeType::String, str_val))
             // }
            _ => Err(ParseError::UnexpectedToken{
                expected: "primary expression (literal, identifier, unary op, or '(')".to_string(),
                found: token,
                context: "expr",
            }),
        }
    }

    // paren_expr: Parse parenthesized expressions
    fn paren_expr(&mut self) -> ParseResult<Box<AstNode>> {
        self.expect(TokenType::Lparen, "paren_expr start")?;
        let node = self.expr(0)?; // Start with lowest precedence inside parens
        self.expect(TokenType::Rparen, "paren_expr end")?;
        Ok(node)
    }

    // stmt: Parse a single statement
    // Returns Option<Box<AstNode>> because ';' might result in no node
    fn stmt(&mut self) -> ParseResult<Option<Box<AstNode>>> {
        match self.current_token.tok_type {
            TokenType::If => {
                self.next_token()?; // Consume 'if'
                let condition = self.paren_expr()?;
                let then_branch = self.stmt()?.ok_or_else(|| ParseError::Custom(
                    "Expected statement after 'if' condition".to_string()
                ))?; // If requires a statement

                let else_branch = if self.check(TokenType::Else) {
                    self.next_token()?; // Consume 'else'
                    Some(self.stmt()?.ok_or_else(|| ParseError::Custom(
                        "Expected statement after 'else'".to_string()
                    ))?)
                } else {
                    None
                };

                // Structure: If(condition, If(then, else)) - mimics C structure
                let if_node = make_node(NodeType::If, Some(then_branch), else_branch);
                Ok(Some(make_node(NodeType::If, Some(condition), Some(if_node))))
            }
            TokenType::Putc => {
                self.next_token()?; // Consume 'putc'
                let arg = self.paren_expr()?;
                let node = make_node(NodeType::Prtc, Some(arg), None);
                self.expect(TokenType::Semi, "putc statement")?;
                Ok(Some(node))
            }
            TokenType::Print => {
                 self.next_token()?; // Consume 'print'
                 self.expect(TokenType::Lparen, "print statement start")?;

                let mut sequence: Option<Box<AstNode>> = None;

                loop {
                    let expr_node = if self.check(TokenType::String) {
                         let str_val = self.consume_text("print string literal")?;
                         make_node(NodeType::Prts, Some(make_leaf(NodeType::String, str_val)), None)
                    } else {
                         make_node(NodeType::Prti, Some(self.expr(0)?), None)
                    };

                    // Build sequence: Sequence(prev_sequence, current_print_expr)
                     sequence = Some(make_node(NodeType::Sequence, sequence, Some(expr_node)));

                    if !self.check(TokenType::Comma) {
                         break; // Exit loop if no more commas
                    }
                    self.next_token()?; // Consume ','
                 }

                self.expect(TokenType::Rparen, "print statement end")?;
                self.expect(TokenType::Semi, "print statement")?;
                Ok(sequence) // Return the sequence of print nodes
            }
            TokenType::Semi => {
                 self.next_token()?; // Consume ';'
                 Ok(None) // Empty statement produces no node
            }
            TokenType::Ident => {
                let ident_token = self.current_token.clone();
                let ident_name = ident_token.text.ok_or_else(|| ParseError::Custom(
                    "Internal error: Identifier token missing text".to_string()
                ))?;
                 self.next_token()?; // Consume identifier

                self.expect(TokenType::Assign, "assignment")?;
                let value_expr = self.expr(0)?; // Assignment has low precedence effectively

                let var_node = make_leaf(NodeType::Ident, ident_name);
                let assign_node = make_node(NodeType::Assign, Some(var_node), Some(value_expr));

                self.expect(TokenType::Semi, "assignment statement")?;
                Ok(Some(assign_node))
            }
            TokenType::While => {
                 self.next_token()?; // Consume 'while'
                 let condition = self.paren_expr()?;
                 let body = self.stmt()?.ok_or_else(|| ParseError::Custom(
                    "Expected statement for 'while' body".to_string()
                 ))?;
                 Ok(Some(make_node(NodeType::While, Some(condition), Some(body))))
            }
            TokenType::Lbrace => {
                 self.next_token()?; // Consume '{'
                 let mut sequence: Option<Box<AstNode>> = None;
                 while !self.check(TokenType::Rbrace) && !self.check(TokenType::Eoi) {
                     if let Some(stmt_node) = self.stmt()? {
                         // Build sequence: Sequence(prev_sequence, current_statement)
                         sequence = Some(make_node(NodeType::Sequence, sequence, Some(stmt_node)));
                     }
                 }
                 self.expect(TokenType::Rbrace, "block statement end")?;
                 Ok(sequence) // Return the sequence of statements in the block
             }
            TokenType::Eoi => Ok(None), // End of input is valid here
             _ => Err(ParseError::UnexpectedToken {
                 expected: "start of statement (if, while, print, putc, {, ;, identifier)".to_string(),
                 found: self.current_token.clone(),
                 context: "stmt",
             }),
        }
    }

    // parse: Main parsing loop, creates sequence of statements
    fn parse(&mut self) -> ParseResult<Box<AstNode>> {
        let mut program_sequence: Option<Box<AstNode>> = None;

        // Loop until End Of Input is the *current* token
        while !self.check(TokenType::Eoi) {
            match self.stmt()? {
                Some(stmt_node) => {
                    // Build sequence: Sequence(prev_sequence, current_statement)
                    program_sequence = Some(make_node(NodeType::Sequence, program_sequence, Some(stmt_node)));
                }
                None => {
                    // Handle empty statements (like ';') - they don't add to the sequence
                }
            }
        }

        // If program_sequence is still None (empty input or only ';'), create an empty sequence.
        // Otherwise, return the built sequence.
        Ok(program_sequence.unwrap_or_else(|| make_node(NodeType::Sequence, None, None)))
    }
}


// --- AST Printing ---

fn prt_ast(node: Option<&AstNode>, indent: usize) {
    let prefix = "  ".repeat(indent);
    match node {
        None => {
            // Represent null children clearly, maybe matching the C output style
             println!("{}<null>", prefix);
             // Or match C output: println!("{};", prefix); but <null> is clearer
        }
        Some(t) => {
            // Use DISPLAY_NODES array, ensure NodeType enum indices match
            let node_name = DISPLAY_NODES.get(t.node_type as usize).unwrap_or(&"UnknownNode");

             match t.node_type {
                 NodeType::Ident | NodeType::Integer | NodeType::String => {
                     println!("{}{:<14} {}", prefix, node_name, t.value.as_deref().unwrap_or(""));
                 }
                 _ => {
                     println!("{}{:<14}", prefix, node_name);
                     prt_ast(t.left.as_deref(), indent + 1);
                     prt_ast(t.right.as_deref(), indent + 1);
                 }
             }
        }
    }
}


// --- Main Function ---

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();

    // --- I/O Setup ---
    // Use Box<dyn Read> to handle both stdin and files
    let reader: Box<dyn Read> = if args.len() > 1 && !args[1].is_empty() {
        Box::new(File::open(&args[1])
            .map_err(|e| format!("Error opening input file '{}': {}", args[1], e))?)
    } else {
        Box::new(io::stdin())
    };
    let buf_reader = BufReader::new(reader);

    // Use Box<dyn Write> for output flexibility (though stdout is typical)
    let writer: Box<dyn Write> = if args.len() > 2 && !args[2].is_empty() {
         Box::new(File::create(&args[2])
            .map_err(|e| format!("Error creating output file '{}': {}", args[2], e))?)
    } else {
         Box::new(io::stdout())
    };
    let mut buf_writer = BufWriter::new(writer); // Not strictly needed for AST printing, but good practice

    // --- Parsing ---
    // Create parser and run it
    let mut parser = Parser::new(buf_reader)
        .map_err(|e| format!("Parser initialization failed: {}", e))?; // Convert ParseError for main's return

    match parser.parse() {
        Ok(ast_root) => {
            // --- AST Printing ---
             // Use a closure to capture buf_writer for printing
             let print_to_writer = |node: Option<&AstNode>, indent: usize| {
                 let prefix = "  ".repeat(indent);
                 match node {
                     None => writeln!(buf_writer, "{}<null>", prefix).unwrap(), // Handle write errors if needed
                     Some(t) => {
                         let node_name = DISPLAY_NODES.get(t.node_type as usize).unwrap_or(&"UnknownNode");
                         match t.node_type {
                             NodeType::Ident | NodeType::Integer | NodeType::String => {
                                 writeln!(buf_writer, "{}{:<14} {}", prefix, node_name, t.value.as_deref().unwrap_or("")).unwrap();
                             }
                             _ => {
                                 writeln!(buf_writer, "{}{:<14}", prefix, node_name).unwrap();
                                 // Recursive calls need access to buf_writer, which is tricky.
                                 // Simpler to pass the writer or print directly for now.
                                 // Let's redefine prt_ast slightly for main.
                             }
                         }
                     }
                 }
             };

            // Redefine prt_ast locally or pass writer - let's redefine for simplicity here
            fn print_ast_to_writer<W: Write>(writer: &mut W, node: Option<&AstNode>, indent: usize) -> io::Result<()> {
                 let prefix = "  ".repeat(indent);
                 match node {
                     None => writeln!(writer, "{}<null>", prefix),
                     Some(t) => {
                         let node_name = DISPLAY_NODES.get(t.node_type as usize).unwrap_or(&"UnknownNode");
                         match t.node_type {
                             NodeType::Ident | NodeType::Integer | NodeType::String => {
                                 writeln!(writer, "{}{:<14} {}", prefix, node_name, t.value.as_deref().unwrap_or(""))?;
                             }
                             _ => {
                                 writeln!(writer, "{}{:<14}", prefix, node_name)?;
                                 print_ast_to_writer(writer, t.left.as_deref(), indent + 1)?;
                                 print_ast_to_writer(writer, t.right.as_deref(), indent + 1)?;
                             }
                         }
                         Ok(())
                     }
                 }
            }

            // Call the modified print function
            print_ast_to_writer(&mut buf_writer, Some(&ast_root), 0)
                 .map_err(|e| format!("Error writing AST: {}", e))?;


            // Ensure output buffer is flushed
             buf_writer.flush()?;
        }
        Err(e) => {
            eprintln!("Parse Error: {}", e); // Print error to stderr
            exit(1); // Exit with non-zero status on error
        }
    }

    Ok(()) // Indicate success
}
