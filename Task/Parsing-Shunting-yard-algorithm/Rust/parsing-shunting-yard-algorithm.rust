type Number = f64;

#[derive(Debug, Copy, Clone, PartialEq)]
struct Operator {
    token: char,
    operation: fn(Number, Number) -> Number,
    precedence: u8,
    is_left_associative: bool,
}

#[derive(Debug, Clone, PartialEq)]
enum Token {
    Digit(Number),
    Operator(Operator),
    LeftParen,
    RightParen,
}

impl Operator {
    fn new_token(
        token: char,
        precedence: u8,
        is_left_associative: bool,
        operation: fn(Number, Number) -> Number,
    ) -> Token {
        Token::Operator(Operator {
            token: token,
            operation: operation,
            precedence: precedence,
            is_left_associative,
        })
    }

    fn apply(&self, x: Number, y: Number) -> Number {
        (self.operation)(x, y)
    }
}

trait Stack<T> {
    fn top(&self) -> Option<T>;
}

impl<T: Clone> Stack<T> for Vec<T> {
    fn top(&self) -> Option<T> {
        if self.is_empty() {
            return None;
        }
        self.last().cloned()
    }
}
fn lex_token(input: char) -> Result<Token, char> {
    let ret = match input {
        '0'...'9' => Token::Digit(input.to_digit(10).unwrap() as Number),
        '+' => Operator::new_token('+', 1, true, |x, y| x + y),
        '-' => Operator::new_token('-', 1, true, |x, y| x - y),
        '*' => Operator::new_token('*', 2, true, |x, y| x * y),
        '/' => Operator::new_token('/', 2, true, |x, y| x / y),
        '^' => Operator::new_token('^', 3, false, |x, y| x.powf(y)),
        '(' => Token::LeftParen,
        ')' => Token::RightParen,
        _ => return Err(input),
    };
    Ok(ret)
}

fn lex(input: String) -> Result<Vec<Token>, char> {
    input
        .chars()
        .filter(|c| !c.is_whitespace())
        .map(lex_token)
        .collect()
}

fn tilt_until(operators: &mut Vec<Token>, output: &mut Vec<Token>, stop: Token) -> bool {
    while let Some(token) = operators.pop() {
        if token == stop {
            return true;
        }
        output.push(token)
    }
    false
}

fn shunting_yard(tokens: Vec<Token>) -> Result<Vec<Token>, String> {
    let mut output: Vec<Token> = Vec::new();
    let mut operators: Vec<Token> = Vec::new();

    for token in tokens {
        match token {
            Token::Digit(_) => output.push(token),
            Token::LeftParen => operators.push(token),
            Token::Operator(operator) => {
                while let Some(top) = operators.top() {
                    match top {
                        Token::LeftParen => break,
                        Token::Operator(top_op) => {
                            let p = top_op.precedence;
                            let q = operator.precedence;
                            if (p > q) || (p == q && operator.is_left_associative) {
                                output.push(operators.pop().unwrap());
                            } else {
                                break;
                            }
                        }
                        _ => unreachable!("{:?} must not be on operator stack", token),
                    }
                }
                operators.push(token);
            }
            Token::RightParen => {
                if !tilt_until(&mut operators, &mut output, Token::LeftParen) {
                    return Err(String::from("Mismatched ')'"));
                }
            }
        }
    }

    if tilt_until(&mut operators, &mut output, Token::LeftParen) {
        return Err(String::from("Mismatched '('"));
    }

    assert!(operators.is_empty());
    Ok(output)
}

fn calculate(postfix_tokens: Vec<Token>) -> Result<Number, String> {
    let mut stack = Vec::new();

    for token in postfix_tokens {
        match token {
            Token::Digit(number) => stack.push(number),
            Token::Operator(operator) => {
                if let Some(y) = stack.pop() {
                    if let Some(x) = stack.pop() {
                        stack.push(operator.apply(x, y));
                        continue;
                    }
                }
                return Err(format!("Missing operand for operator '{}'", operator.token));
            }
            _ => unreachable!("Unexpected token {:?} during calculation", token),
        }
    }

    assert!(stack.len() == 1);
    Ok(stack.pop().unwrap())
}

fn run(input: String) -> Result<Number, String> {
    let tokens = match lex(input) {
        Ok(tokens) => tokens,
        Err(c) => return Err(format!("Invalid character: {}", c)),
    };
    let postfix_tokens = match shunting_yard(tokens) {
        Ok(tokens) => tokens,
        Err(message) => return Err(message),
    };

    calculate(postfix_tokens)
}
