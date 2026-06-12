// Add this to Cargo.toml:
// [dependencies]
// regex = "1.11.1"

extern crate regex; // 1.11.1
use regex::Regex;
use std::error::Error;
use std::fmt;

// Custom error type for validation errors
#[derive(Debug)]
struct ValidationError {
    message: String,
}

impl fmt::Display for ValidationError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.message)
    }
}

impl Error for ValidationError {}

impl ValidationError {
    fn new(message: String) -> Self {
        ValidationError { message }
    }
}

struct ExpressionValidator {
    re1: Regex,
    re2: Regex,
    re3: Regex,
    re4: Regex,
    subs: Vec<(&'static str, &'static str)>,
}

impl ExpressionValidator {
    fn new() -> Self {
        ExpressionValidator {
            re1: Regex::new(r"[^_a-zA-Z0-9\+\-\*/=<\(\)\s]").unwrap(),
            re2: Regex::new(r"\b_\w*\b").unwrap(),
            re3: Regex::new(r"[=<+*/-]\s*not").unwrap(),
            re4: Regex::new(r"(=|<)\s*[^(=< ]+\s*([=<+*/-])").unwrap(),
            subs: vec![
                ("=", "=="),
                (" not ", " ! "),
                ("(not ", "(! "),
                (" or ", " || "),
                (" and ", " && "),
            ],
        }
    }

    fn possibly_valid(&self, expr: &str) -> Result<(), ValidationError> {
        // Check for invalid characters
        if let Some(mat) = self.re1.find(expr) {
            let invalid_char = mat.as_str().chars().next().unwrap();
            return Err(ValidationError::new(format!(
                "invalid character {:?} found",
                invalid_char
            )));
        }

        // Check for identifiers beginning with underscore
        if self.re2.is_match(expr) {
            return Err(ValidationError::new(
                "identifier cannot begin with an underscore".to_string(),
            ));
        }

        // Check for 'not' after operators
        if self.re3.is_match(expr) {
            return Err(ValidationError::new(
                "expected operand, found 'not'".to_string(),
            ));
        }

        // Check for non-associative operators
        if let Some(captures) = self.re4.captures(expr) {
            let operator = captures.get(1).unwrap().as_str().chars().next().unwrap();
            return Err(ValidationError::new(format!(
                "operator {:?} is non-associative",
                operator
            )));
        }

        Ok(())
    }

    fn modify_error(&self, err_msg: &str) -> String {
        let mut modified = err_msg.to_string();

        // Apply substitutions in reverse
        for (from, to) in &self.subs {
            modified = modified.replace(to.trim(), from.trim());
        }

        // Remove location info (simulate Go's behavior)
        if let Some(colon_pos) = modified.rfind(':') {
            if let Some(second_colon) = modified[..colon_pos].rfind(':') {
                return modified[second_colon + 2..].to_string();
            }
        }

        modified
    }

    fn validate_expression(&self, expr: &str) -> (bool, String) {
        // First check basic validation
        if let Err(err) = self.possibly_valid(expr) {
            return (false, err.to_string());
        }

        // Apply substitutions for parsing
        let mut modified_expr = format!(" {} ", expr);
        for (from, to) in &self.subs {
            modified_expr = modified_expr.replace(from, to);
        }

        // Since Rust doesn't have a built-in Go parser equivalent,
        // we'll do a basic syntax check for demonstration
        // In a real implementation, you'd use a proper expression parser
        match self.basic_syntax_check(&modified_expr) {
            Ok(_) => (true, String::new()),
            Err(err) => (false, self.modify_error(&err.to_string())),
        }
    }

    // Basic syntax checking (simplified version of what Go's parser does)
    fn basic_syntax_check(&self, expr: &str) -> Result<(), ValidationError> {
        let expr = expr.trim();

        // Check for balanced parentheses
        let mut paren_count = 0;
        for ch in expr.chars() {
            match ch {
                '(' => paren_count += 1,
                ')' => {
                    paren_count -= 1;
                    if paren_count < 0 {
                        return Err(ValidationError::new("unbalanced parentheses".to_string()));
                    }
                }
                _ => {}
            }
        }

        if paren_count != 0 {
            return Err(ValidationError::new("expected ')'".to_string()));
        }

        // Check for invalid number sequences (like "235 76")
        let number_seq_regex = Regex::new(r"\b\d+\s+\d+\b").unwrap();
        if number_seq_regex.is_match(expr) {
            return Err(ValidationError::new("expected operator".to_string()));
        }

        // Check for invalid operator sequences
        let invalid_ops = Regex::new(r"[+\-*/=<]{2,}|[+\-*/=<]\s*$|^\s*[+\-*/=<]").unwrap();
        if invalid_ops.is_match(expr) {
            return Err(ValidationError::new("expected operand".to_string()));
        }

        // Check for increment operators (not supported)
        if expr.contains("++") || expr.contains("--") {
            return Err(ValidationError::new("expected operand".to_string()));
        }

        // Check for bitwise operators (not supported in this context)
        if expr.contains(" & ") {
            return Err(ValidationError::new("expected operand".to_string()));
        }

        Ok(())
    }
}

fn main() {
    let validator = ExpressionValidator::new();

    let exprs = vec![
        "$",
        "one",
        "either or both",
        "a + 1",
        "a + b < c",
        "a = b",
        "a or b = c",
        "3 + not 5",
        "3 + (not 5)",
        "(42 + 3",
        "(42 + 3)",
        " not 3 < 4 or (true or 3 /  4 + 8 *  5 - 5 * 2 < 56) and 4 * 3  < 12 or not true",
        " and 3 < 2",
        "not 7 < 2",
        "2 < 3 < 4",
        "2 < (3 < 4)",
        "2 < foobar - 3 < 4",
        "2 < foobar and 3 < 4",
        "4 * (32 - 16) + 9 = 73",
        "235 76 + 1",
        "true or false = not true",
        "true or false = (not true)",
        "not true or false = false",
        "not true = false",
        "a + b = not c and false",
        "a + b = (not c) and false",
        "a + b = (not c and false)",
        "ab_c / bd2 or < e_f7",
        "g not = h",
        "été = false",
        "i++",
        "j & k",
        "l or _m",
    ];

    for expr in exprs {
        println!("Statement to verify: {:?}", expr);
        let (is_valid, error_msg) = validator.validate_expression(expr);

        if is_valid {
            println!("\"true\"");
        } else {
            println!("\"false\" -> {}", error_msg);
        }
        println!();
    }
}
