use std::collections::BTreeMap;
use std::fmt;

#[derive(Copy, Clone)]
enum Operator {
    None,
    Plus,
    Minus,
}

#[derive(Clone)]
struct Expression {
    ops: [Operator; 9],
}

impl Expression {
    fn new() -> Expression {
        Expression {
            ops: [Operator::None; 9],
        }
    }
    fn sum(&self) -> i32 {
        let mut result: i32 = 0;
        let mut n: i32 = 0;
        let mut p: i32 = 1;
        let mut i: usize = 9;
        while i > 0 {
            n += p * (i as i32);
            i -= 1;
            match self.ops[i] {
                Operator::None => p *= 10,
                Operator::Plus => {
                    p = 1;
                    result += n;
                    n = 0;
                }
                Operator::Minus => {
                    p = 1;
                    result -= n;
                    n = 0;
                }
            }
        }
        result += n;
        result
    }
    fn next(&mut self) -> bool {
        let mut i: usize = 9;
        while i > 0 {
            i -= 1;
            match self.ops[i] {
                Operator::None => {
                    self.ops[i] = if i == 0 {
                        Operator::Minus
                    } else {
                        Operator::Plus
                    };
                    return true;
                }
                Operator::Plus => {
                    self.ops[i] = Operator::Minus;
                    return true;
                }
                Operator::Minus => self.ops[i] = Operator::None,
            }
        }
        false
    }
}

impl fmt::Display for Expression {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        for i in 0..9 {
            match self.ops[i] {
                Operator::None => {}
                Operator::Plus => write!(f, "+")?,
                Operator::Minus => write!(f, "-")?,
            }
            write!(f, "{}", i + 1)?;
        }
        Ok(())
    }
}

fn main() {
    let mut exp = Expression::new();
    let mut sums: BTreeMap<i32, Vec<Expression>> = BTreeMap::new();
    loop {
        sums.entry(exp.sum()).or_insert(Vec::new()).push(exp.clone());
        if !exp.next() {
            break;
        }
    }

    println!("Solutions that sum to 100:");
    if let Some(expressions) = sums.get(&100) {
        for e in expressions {
            println!("100 = {}", e);
        }
    }

    let mut max_sum = 0;
    let mut max_count = 0;
    for (sum, expressions) in &sums {
        let count = expressions.len();
        if count > max_count {
            max_count = count;
            max_sum = *sum;
        }
    }
    println!(
        "\nThe sum with the greatest number of solutions is {} ({}).",
        max_sum, max_count
    );

    let mut n = 1;
    while sums.contains_key(&n) {
        n += 1;
    }
    println!(
        "\nThe smallest positive number that cannot be expressed is {}.",
        n
    );

    println!("\nThe ten highest numbers that can be expressed are:");
    for (sum, expressions) in sums.iter().rev().take(10) {
        println!("{} = {}", sum, expressions[0]);
    }
}
