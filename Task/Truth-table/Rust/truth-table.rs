use std::{
    collections::HashMap,
    fmt::{Display, Formatter},
    iter::FromIterator,
};

// Generic expression evaluation automaton and expression formatting support

#[derive(Clone, Debug)]
pub enum EvaluationError<T> {
    NoResults,
    TooManyResults,
    OperatorFailed(T),
}

pub trait Operator<T> {
    type Err;

    fn execute(&self, stack: &mut Vec<T>) -> Result<(), Self::Err>;
}

#[derive(Clone, Copy, Debug)]
enum Element<O> {
    Operator(O),
    Variable(usize),
}

#[derive(Clone, Debug)]
pub struct Expression<O> {
    elements: Vec<Element<O>>,
    symbols: Vec<String>,
}

impl<O> Expression<O> {
    pub fn evaluate<T>(
        &self,
        mut bindings: impl FnMut(usize) -> T,
    ) -> Result<T, EvaluationError<O::Err>>
    where
        O: Operator<T>,
    {
        let mut stack = Vec::new();

        for element in self.elements.iter() {
            match element {
                Element::Variable(index) => stack.push(bindings(*index)),
                Element::Operator(op) => op
                    .execute(&mut stack)
                    .map_err(EvaluationError::OperatorFailed)?,
            }
        }

        match stack.pop() {
            Some(result) if stack.is_empty() => Ok(result),
            Some(_) => Err(EvaluationError::TooManyResults),
            None => Err(EvaluationError::NoResults),
        }
    }

    pub fn symbols(&self) -> &[String] {
        &self.symbols
    }

    pub fn formatted(&self) -> Result<String, EvaluationError<O::Err>>
    where
        O: Operator<Formatted>,
    {
        self.evaluate(|index| Formatted(self.symbols[index].clone()))
            .map(|formatted| formatted.0)
    }
}

#[derive(Clone, Debug)]
pub struct Formatted(pub String);

impl Display for Formatted {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}

impl<O> Display for Expression<O>
where
    O: Operator<Formatted>,
{
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        match self.formatted() {
            Ok(result) => write!(f, "{}", result),
            Err(_) => write!(f, "<malformed expression>"),
        }
    }
}

// Generic parts of the parsing machinery

#[derive(Clone, Copy, Debug)]
pub enum Token<'a, O> {
    LBrace,
    RBrace,
    Operator(O),
    Variable(&'a str),
    Malformed(&'a str),
}

pub type Symbol<'a, O> = (&'a str, bool, Token<'a, O>);

#[derive(Debug)]
pub struct Tokens<'a, O> {
    source: &'a str,
    symbols: &'a [Symbol<'a, O>],
}

impl<'a, O> Tokens<'a, O> {
    pub fn new(source: &'a str, symbols: &'a [Symbol<'a, O>]) -> Self {
        Self { source, symbols }
    }
}

impl<'a, O: Clone> Iterator for Tokens<'a, O> {
    type Item = Token<'a, O>;

    fn next(&mut self) -> Option<Self::Item> {
        self.source = self.source.trim_start();

        let symbol = self.symbols.iter().find_map(|(symbol, word, token)| {
            if self.source.starts_with(symbol) {
                let end = symbol.len();

                if *word {
                    match &self.source[end..].chars().next() {
                        Some(c) if !c.is_whitespace() => return None,
                        _ => (),
                    }
                }

                Some((token, end))
            } else {
                None
            }
        });

        if let Some((token, end)) = symbol {
            self.source = &self.source[end..];
            Some(token.clone())
        } else {
            match self.source.chars().next() {
                Some(c) if c.is_alphabetic() => {
                    let end = self
                        .source
                        .char_indices()
                        .find_map(|(i, c)| Some(i).filter(|_| !c.is_alphanumeric()))
                        .unwrap_or_else(|| self.source.len());

                    let result = &self.source[0..end];
                    self.source = &self.source[end..];
                    Some(Token::Variable(result))
                }

                Some(c) => {
                    let end = c.len_utf8();
                    let result = &self.source[0..end];
                    self.source = &self.source[end..];
                    Some(Token::Malformed(result))
                }

                None => None,
            }
        }
    }
}

pub trait WithPriority {
    type Priority;

    fn priority(&self) -> Self::Priority;
}

impl<'a, O> FromIterator<Token<'a, O>> for Result<Expression<O>, Token<'a, O>>
where
    O: WithPriority,
    O::Priority: Ord,
{
    fn from_iter<T: IntoIterator<Item = Token<'a, O>>>(tokens: T) -> Self {
        let mut token_stack = Vec::new();
        let mut indices = HashMap::new();
        let mut symbols = Vec::new();
        let mut elements = Vec::new();

        'outer: for token in tokens {
            match token {
                Token::Malformed(_) => return Err(token),
                Token::LBrace => token_stack.push(token),
                Token::RBrace => {
                    // Flush all operators to the matching LBrace
                    while let Some(token) = token_stack.pop() {
                        match token {
                            Token::LBrace => continue 'outer,
                            Token::Operator(op) => elements.push(Element::Operator(op)),
                            _ => return Err(token),
                        }
                    }
                }

                Token::Variable(name) => {
                    let index = indices.len();
                    let symbol = name.to_string();
                    let index = *indices.entry(symbol.clone()).or_insert_with(|| {
                        symbols.push(symbol);
                        index
                    });

                    elements.push(Element::Variable(index));
                }

                Token::Operator(ref op) => {
                    while let Some(token) = token_stack.pop() {
                        match token {
                            Token::Operator(pop) if op.priority() < pop.priority() => {
                                elements.push(Element::Operator(pop));
                            }

                            Token::Operator(pop) => {
                                token_stack.push(Token::Operator(pop));
                                break;
                            }

                            _ => {
                                token_stack.push(token);
                                break;
                            }
                        }
                    }

                    token_stack.push(token);
                }
            }
        }

        // Handle leftovers
        while let Some(token) = token_stack.pop() {
            match token {
                Token::Operator(op) => elements.push(Element::Operator(op)),
                _ => return Err(token),
            }
        }

        Ok(Expression { elements, symbols })
    }
}

// Definition of Boolean operators

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Boolean {
    Or,
    Xor,
    And,
    Not,
}

impl Display for Boolean {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        let s = match self {
            Self::Or => "∨",
            Self::And => "∧",
            Self::Not => "¬",
            Self::Xor => "⩛",
        };

        write!(f, "{}", s)
    }
}

impl WithPriority for Boolean {
    type Priority = u8;

    fn priority(&self) -> u8 {
        match self {
            Self::Or => 0,
            Self::Xor => 1,
            Self::And => 2,
            Self::Not => 3,
        }
    }
}

#[derive(Clone, Debug)]
pub enum BooleanError {
    StackUnderflow,
}

impl Operator<bool> for Boolean {
    type Err = BooleanError;

    fn execute(&self, stack: &mut Vec<bool>) -> Result<(), Self::Err> {
        let mut pop = || stack.pop().ok_or(BooleanError::StackUnderflow);

        let result = match self {
            Boolean::Or => pop()? | pop()?,
            Boolean::And => pop()? & pop()?,
            Boolean::Xor => pop()? ^ pop()?,
            Boolean::Not => !pop()?,
        };

        stack.push(result);
        Ok(())
    }
}

impl Operator<Formatted> for Boolean {
    type Err = BooleanError;

    fn execute(&self, stack: &mut Vec<Formatted>) -> Result<(), Self::Err> {
        let mut pop = || stack.pop().ok_or(BooleanError::StackUnderflow);

        let result = match self {
            Boolean::Not => format!("{}{}", Boolean::Not, pop()?),

            binary_operator => {
                // The stack orders the operands backwards, so to format them
                // properly, we have to count with the reversed popping order
                let b = pop()?;
                let a = pop()?;
                format!("({} {} {})", a, binary_operator, b)
            }
        };

        stack.push(Formatted(result));
        Ok(())
    }
}

impl Boolean {
    // It is important for the tokens to be ordered by their parsing priority (if
    // some operator was a prefix of another operator, the prefix must come later)
    const SYMBOLS: [Symbol<'static, Boolean>; 18] = [
        ("(", false, Token::LBrace),
        (")", false, Token::RBrace),
        ("|", false, Token::Operator(Boolean::Or)),
        ("∨", false, Token::Operator(Boolean::Or)),
        ("or", true, Token::Operator(Boolean::Or)),
        ("OR", true, Token::Operator(Boolean::Or)),
        ("&", false, Token::Operator(Boolean::And)),
        ("∧", false, Token::Operator(Boolean::And)),
        ("and", true, Token::Operator(Boolean::And)),
        ("AND", true, Token::Operator(Boolean::And)),
        ("!", false, Token::Operator(Boolean::Not)),
        ("¬", false, Token::Operator(Boolean::Not)),
        ("not", true, Token::Operator(Boolean::Not)),
        ("NOT", true, Token::Operator(Boolean::Not)),
        ("^", false, Token::Operator(Boolean::Xor)),
        ("⩛", false, Token::Operator(Boolean::Xor)),
        ("xor", true, Token::Operator(Boolean::Xor)),
        ("XOR", true, Token::Operator(Boolean::Xor)),
    ];

    pub fn tokenize(s: &str) -> Tokens<'_, Boolean> {
        Tokens::new(s, &Self::SYMBOLS)
    }

    pub fn parse<'a>(s: &'a str) -> Result<Expression<Boolean>, Token<'a, Boolean>> {
        Self::tokenize(s).collect()
    }
}

// Finally the table printing

fn print_truth_table(s: &str) -> Result<(), std::borrow::Cow<'_, str>> {
    let expression = Boolean::parse(s).map_err(|e| format!("Parsing failed at token {:?}", e))?;

    let formatted = expression
        .formatted()
        .map_err(|_| "Malformed expression detected.")?;

    let var_count = expression.symbols().len();
    if var_count > 64 {
        return Err("Too many variables to list.".into());
    }

    let column_widths = {
        // Print header and compute the widths of columns
        let mut widths = Vec::with_capacity(var_count);

        for symbol in expression.symbols() {
            print!("{}  ", symbol);
            widths.push(symbol.chars().count() + 2); // Include spacing
        }

        println!("{}", formatted);
        let width = widths.iter().sum::<usize>() + formatted.chars().count();
        (0..width).for_each(|_| print!("-"));
        println!();

        widths
    };

    // Choose the bit extraction order for the more traditional table ordering
    let var_value = |input, index| (input >> (var_count - 1 - index)) & 1 ^ 1;
    // Use counter to enumerate all bit combinations
    for var_values in 0u64..(1 << var_count) {
        for (var_index, width) in column_widths.iter().enumerate() {
            let value = var_value(var_values, var_index);
            print!("{:<width$}", value, width = width);
        }

        match expression.evaluate(|var_index| var_value(var_values, var_index) == 1) {
            Ok(result) => println!("{}", if result { "1" } else { "0" }),
            Err(e) => println!("{:?}", e),
        }
    }

    println!();
    Ok(())
}

fn main() {
    loop {
        let input = {
            println!("Enter the expression to parse (or nothing to quit):");
            let mut input = String::new();
            std::io::stdin().read_line(&mut input).unwrap();
            println!();
            input
        };

        if input.trim().is_empty() {
            break;
        }

        if let Err(e) = print_truth_table(&input) {
            eprintln!("{}\n", e);
        }
    }
}
