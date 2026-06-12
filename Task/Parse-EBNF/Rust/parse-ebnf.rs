use std::collections::HashMap;

#[derive(Debug, Clone)]
enum Token {
    Char(char),
    Sequence(Vec<String>),
    EOF,
}

#[derive(Debug, Clone)]
enum Rule {
    Terminal(String),
    Ident(String, usize),
    Or(Vec<Rule>),
    Repeat(Box<Rule>),
    Optional(Box<Rule>),
    Sequence(Vec<Rule>),
}

pub struct EBNFParser {
    src: String,
    ch: char,
    sdx: usize,
    token: Token,
    err: bool,
    idents: Vec<String>,
    ididx: Vec<Option<usize>>,
    productions: Vec<(String, usize, Rule)>,
    extras: Vec<Vec<String>>,
}

impl EBNFParser {
    pub fn new() -> Self {
        EBNFParser {
            src: String::new(),
            ch: '\0',
            sdx: 0,
            token: Token::EOF,
            err: false,
            idents: Vec::new(),
            ididx: Vec::new(),
            productions: Vec::new(),
            extras: Vec::new(),
        }
    }

    fn btoi(&self, b: bool) -> usize {
        if b { 1 } else { 0 }
    }

    fn invalid(&mut self, msg: &str) -> i32 {
        self.err = true;
        println!("{}", msg);
        self.sdx = self.src.len(); // set to eof
        -1
    }

    fn skip_spaces(&mut self) {
        while self.sdx < self.src.len() {
            self.ch = self.src.chars().nth(self.sdx).unwrap_or('\0');
            if ![' ', '\t', '\r', '\n'].contains(&self.ch) {
                break;
            }
            self.sdx += 1;
        }
    }

    fn get_token(&mut self) {
        // Yields a single character token, one of {}()[]|=.;
        // or ["terminal",string] or ["ident", string] or EOF.
        self.skip_spaces();
        if self.sdx >= self.src.len() {
            self.token = Token::EOF;
            return;
        }
        let tokstart = self.sdx;

        if "{}()[]|=.;".contains(self.ch) {
            self.sdx += 1;
            self.token = Token::Char(self.ch);
        } else if self.ch == '"' || self.ch == '\'' {
            let closech = self.ch;
            let mut tokend = tokstart + 1;
            while tokend < self.src.len() && self.src.chars().nth(tokend).unwrap_or('\0') != closech {
                tokend += 1;
            }
            if tokend >= self.src.len() {
                self.invalid("no closing quote");
                self.token = Token::EOF;
            } else {
                self.sdx = tokend + 1;
                let content = self.src[tokstart + 1..tokend].to_string();
                self.token = Token::Sequence(vec!["terminal".to_string(), content]);
            }
        } else if self.ch.is_ascii_lowercase() {
            // To simplify things for the purposes of this task,
            // identifiers are strictly a-z only, not A-Z or 1-9.
            while self.sdx < self.src.len() {
                self.ch = self.src.chars().nth(self.sdx).unwrap_or('\0');
                if !self.ch.is_ascii_lowercase() {
                    break;
                }
                self.sdx += 1;
            }
            let ident = self.src[tokstart..self.sdx].to_string();
            self.token = Token::Sequence(vec!["ident".to_string(), ident]);
        } else {
            self.invalid("invalid ebnf");
            self.token = Token::EOF;
        }
    }

    fn match_token(&mut self, expected_ch: char) {
        if !matches!(&self.token, Token::Char(ch) if *ch == expected_ch) {
            self.invalid(&format!("invalid ebnf ({} expected)", expected_ch));
        } else {
            self.get_token();
        }
    }

    fn add_ident(&mut self, ident: String) -> usize {
        if let Some(k) = self.idents.iter().position(|x| x == &ident) {
            k
        } else {
            self.idents.push(ident);
            let k = self.idents.len() - 1;
            self.ididx.push(None);
            k
        }
    }

    fn factor(&mut self) -> Result<Rule, String> {
        match &self.token.clone() {
            Token::Sequence(t) => {
                if t[0] == "ident" {
                    let idx = self.add_ident(t[1].clone());
                    let rule = Rule::Ident(t[1].clone(), idx);
                    self.get_token();
                    Ok(rule)
                } else if t[0] == "terminal" {
                    let rule = Rule::Terminal(t[1].clone());
                    self.get_token();
                    Ok(rule)
                } else {
                    Err("invalid token sequence".to_string())
                }
            }
            Token::Char('[') => {
                self.get_token();
                let expr = self.expression()?;
                self.match_token(']');
                Ok(Rule::Optional(Box::new(expr)))
            }
            Token::Char('(') => {
                self.get_token();
                let expr = self.expression()?;
                self.match_token(')');
                Ok(expr)
            }
            Token::Char('{') => {
                self.get_token();
                let expr = self.expression()?;
                self.match_token('}');
                Ok(Rule::Repeat(Box::new(expr)))
            }
            _ => Err("invalid token in factor() function".to_string()),
        }
    }

    fn term(&mut self) -> Result<Rule, String> {
        let mut factors = vec![self.factor()?];

        let stop_tokens = [Token::EOF, Token::Char('|'), Token::Char('.'), Token::Char(';'),
                          Token::Char(')'), Token::Char(']'), Token::Char('}')];

        while !stop_tokens.iter().any(|t| std::mem::discriminant(t) == std::mem::discriminant(&self.token)) {
            factors.push(self.factor()?);
        }

        if factors.len() == 1 {
            Ok(factors.into_iter().next().unwrap())
        } else {
            Ok(Rule::Sequence(factors))
        }
    }

    fn expression(&mut self) -> Result<Rule, String> {
        let first_term = self.term()?;

        if matches!(self.token, Token::Char('|')) {
            let mut terms = vec![first_term];
            while matches!(self.token, Token::Char('|')) {
                self.get_token();
                terms.push(self.term()?);
            }
            Ok(Rule::Or(terms))
        } else {
            Ok(first_term)
        }
    }

    fn production(&mut self) -> Result<Token, String> {
        // Returns a token or EOF; the real result is left in 'productions' etc,
        self.get_token();
        if matches!(self.token, Token::Char('}')) {
            return Ok(self.token.clone());
        }
        if matches!(self.token, Token::EOF) {
            self.invalid("invalid ebnf (missing closing })");
            return Ok(Token::EOF);
        }

        if let Token::Sequence(t) = &self.token {
            if t[0] == "ident" {
                let ident = t[1].clone();
                let idx = self.add_ident(ident.clone());
                self.get_token();
                self.match_token('=');
                if matches!(self.token, Token::EOF) {
                    return Ok(Token::EOF);
                }
                let expr = self.expression()?;
                self.productions.push((ident, idx, expr));
                self.ididx[idx] = Some(self.productions.len() - 1);
                return Ok(self.token.clone());
            }
        }

        Ok(Token::EOF)
    }

    pub fn parse(&mut self, ebnf: &str) -> i32 {
        // Returns +1 if ok, -1 if bad.
        println!("parse:\n{} ===>\n", ebnf);
        self.err = false;
        self.src = ebnf.to_string();
        self.sdx = 0;
        self.idents.clear();
        self.ididx.clear();
        self.productions.clear();
        self.extras.clear();

        self.get_token();
        if let Token::Sequence(mut t) = self.token.clone() {
            t[0] = "title".to_string();
            self.extras.push(t);
            self.get_token();
        }

        if !matches!(self.token, Token::Char('{')) {
            return self.invalid("invalid ebnf (missing opening {)");
        }

        loop {
            match self.production() {
                Ok(Token::Char('}')) | Ok(Token::EOF) => break,
                Err(_) => return -1,
                _ => continue,
            }
        }

        self.get_token();
        if let Token::Sequence(mut t) = self.token.clone() {
            t[0] = "comment".to_string();
            self.extras.push(t);
            self.get_token();
        }

        if !matches!(self.token, Token::EOF) {
            return self.invalid("invalid ebnf (missing eof?)");
        }
        if self.err {
            return -1;
        }

        // Check for undefined identifiers
        for (i, ididx_val) in self.ididx.iter().enumerate() {
            if ididx_val.is_none() {
                return self.invalid(&format!("invalid ebnf (undefined:{})", self.idents[i]));
            }
        }

        self.pprint_productions();
        self.pprint_idents();
        self.pprint_ididx();
        self.pprint_extras();
        1
    }

    fn pprint_productions(&self) {
        println!("\nproductions:");
        println!("{:?}", self.productions);
    }

    fn pprint_idents(&self) {
        println!("\nidents:");
        println!("{:?}", self.idents);
    }

    fn pprint_ididx(&self) {
        println!("\nididx:");
        println!("{:?}", self.ididx);
    }

    fn pprint_extras(&self) {
        println!("\nextras:");
        println!("{:?}", self.extras);
    }

    fn applies(&self, rule: &Rule, src: &str, sdx: &mut usize) -> bool {
        let was_sdx = *sdx;

        match rule {
            Rule::Sequence(rules) => {
                for rule in rules {
                    if !self.applies(rule, src, sdx) {
                        *sdx = was_sdx;
                        return false;
                    }
                }
                true
            }
            Rule::Terminal(terminal) => {
                self.skip_spaces_at(src, sdx);
                for ch in terminal.chars() {
                    if *sdx >= src.len() || src.chars().nth(*sdx).unwrap_or('\0') != ch {
                        *sdx = was_sdx;
                        return false;
                    }
                    *sdx += 1;
                }
                true
            }
            Rule::Or(rules) => {
                for rule in rules {
                    if self.applies(rule, src, sdx) {
                        return true;
                    }
                }
                *sdx = was_sdx;
                false
            }
            Rule::Repeat(rule) => {
                while self.applies(rule, src, sdx) {
                    // continue repeating
                }
                true
            }
            Rule::Optional(rule) => {
                self.applies(rule, src, sdx);
                true
            }
            Rule::Ident(_name, idx) => {
                if let Some(prod_idx) = self.ididx[*idx] {
                    if !self.applies(&self.productions[prod_idx].2, src, sdx) {
                        *sdx = was_sdx;
                        return false;
                    }
                    true
                } else {
                    false
                }
            }
        }
    }

    fn skip_spaces_at(&self, src: &str, sdx: &mut usize) {
        while *sdx < src.len() {
            let ch = src.chars().nth(*sdx).unwrap_or('\0');
            if ![' ', '\t', '\r', '\n'].contains(&ch) {
                break;
            }
            *sdx += 1;
        }
    }

    fn check_valid(&self, test: &str) {
        let mut sdx = 0;
        let res = self.applies(&self.productions[0].2, test, &mut sdx);
        self.skip_spaces_at(test, &mut sdx);
        let final_res = res && sdx >= test.len();
        let result = if final_res { "pass" } else { "fail" };
        println!("\"{}\", {}", test, result);
    }
}

fn main() {
    let mut parser = EBNFParser::new();

    let ebnfs = [
        r#""a" {
    a = "a1" ( "a2" | "a3" ) { "a4" } [ "a5" ] "a6" ;
} "z" "#,
        r#"{
    expr = term { plus term } .
    term = factor { times factor } .
    factor = number | '(' expr ')' .

    plus = "+" | "-" .
    times = "*" | "/" .

    number = digit { digit } .
    digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" .
}"#,
        r#"a = "1""#,
        r#"{ a = "1" ;"#,
        r#"{ hello world = "1"; }"#,
        r#"{ foo = bar . }"#,
    ];

    let tests = [
        vec![
            "a1a3a4a4a5a6",
            "a1 a2a6",
            "a1 a3 a4 a6",
            "a1 a4 a5 a6",
            "a1 a2 a4 a5 a5 a6",
            "a1 a2 a4 a5 a6 a7",
            "your ad here",
        ],
        vec![
            "2",
            "2*3 + 4/23 - 7",
            "(3 + 4) * 6-2+(4*(4))",
            "-2",
            "3 +",
            "(4 + 3",
        ],
    ];

    for (i, ebnf) in ebnfs.iter().enumerate() {
        if parser.parse(ebnf) == 1 {
            println!("\ntests:");
            if i < tests.len() {
                for test in &tests[i] {
                    parser.check_valid(test);
                }
            }
        }
        println!();
    }
}
