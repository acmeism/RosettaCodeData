use std::collections::BTreeSet;
use std::cmp::{max, min, Ordering};
use std::fmt;

#[derive(Clone, Debug, Eq, PartialEq)]
struct Lunar {
    text: String,
}

impl Lunar {
    fn new(n: i64) -> Result<Self, &'static str> {
        if n < 0 {
            return Err("Argument must be a non-negative integer.");
        }
        Ok(Lunar {
            text: n.to_string(),
        })
    }

    fn add(&self, other: &Lunar) -> Lunar {
        let max_length = max(self.text.len(), other.text.len());
        let a = format!("{:0>width$}", self.text, width = max_length);
        let b = format!("{:0>width$}", other.text, width = max_length);

        let sum: String = a.chars()
            .zip(b.chars())
            .map(|(c1, c2)| max(c1, c2))
            .collect();

        Lunar::new(sum.parse().unwrap()).unwrap()
    }

    fn multiply(&self, other: &Lunar) -> Lunar {
        let mut result = Lunar::new(0).unwrap();
        let reversed: String = other.text.chars().rev().collect();

        for (i, digit) in reversed.chars().enumerate() {
            let mut row = String::new();
            for c in self.text.chars() {
                row.push(min(c, digit));
            }
            row.push_str(&"0".repeat(i));

            let row_value = Lunar::new(row.parse().unwrap()).unwrap();
            result = result.add(&row_value);
        }

        result
    }

    fn increment(&self) -> Lunar {
        let value: i64 = self.text.parse().unwrap();
        Lunar::new(value + 1).unwrap()
    }

    fn to_string(&self) -> &str {
        &self.text
    }
}

impl PartialOrd for Lunar {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Lunar {
    fn cmp(&self, other: &Self) -> Ordering {
        let self_val: i64 = self.text.parse().unwrap();
        let other_val: i64 = other.text.parse().unwrap();
        self_val.cmp(&other_val)
    }
}

impl fmt::Display for Lunar {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.text)
    }
}

fn main() {
    let tests = vec![
        vec![976, 348],
        vec![23, 321],
        vec![232, 35],
        vec![123, 32192, 415, 8],
    ];

    for test in &tests {
        let mut add_expression = String::new();
        let mut multiply_expression = String::new();
        let mut add_result = Lunar::new(0).unwrap();
        let mut multiply_result = Lunar::new(9).unwrap();

        for (i, &value) in test.iter().enumerate() {
            if i > 0 {
                add_expression.push_str(" 🌙 + ");
                multiply_expression.push_str(" 🌙 x ");
            }
            add_expression.push_str(&value.to_string());
            multiply_expression.push_str(&value.to_string());

            let lunar_value = Lunar::new(value).unwrap();
            add_result = add_result.add(&lunar_value);
            multiply_result = multiply_result.multiply(&lunar_value);
        }

        println!("{} = {}", add_expression, add_result.to_string());
        println!("{} = {}", multiply_expression, multiply_result.to_string());
        println!();
    }

    println!("First 20 distinct lunar even numbers:");
    let mut evens = BTreeSet::new();
    let mut n = Lunar::new(0).unwrap();
    while evens.len() < 20 {
        evens.insert(n.multiply(&Lunar::new(2).unwrap()));
        n = n.increment();
    }
    for lunar in &evens {
        print!("{} ", lunar.to_string());
    }
    println!();
    println!();

    println!("First 20 lunar square numbers:");
    for i in 0..20 {
        let lunar_i = Lunar::new(i).unwrap();
        print!("{} ", lunar_i.multiply(&lunar_i).to_string());
    }
    println!();
    println!();

    println!("First 20 lunar factorials:");
    let mut factorial = Lunar::new(1).unwrap();
    for i in 1..=20 {
        factorial = factorial.multiply(&Lunar::new(i).unwrap());
        print!("{} ", factorial.to_string());
    }
    println!();
    println!();

    let mut current = Lunar::new(0).unwrap();
    let mut next = Lunar::new(1).unwrap();
    while current.multiply(&current) < next.multiply(&next) {
        current = next.clone();
        next = next.increment();
    }
    println!("First number whose lunar square is smaller than the previous: {}", next.to_string());
}
