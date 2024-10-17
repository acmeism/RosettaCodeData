use std::{ops, fmt};

#[derive(Copy, Clone, Debug)]
enum Trit {
    True,
    Maybe,
    False,
}

impl ops::Not for Trit {
    type Output = Self;
    fn not(self) -> Self {
        match self {
            Trit::True => Trit::False,
            Trit::Maybe => Trit::Maybe,
            Trit::False => Trit::True,
        }
    }
}

impl ops::BitAnd for Trit {
    type Output = Self;
    fn bitand(self, other: Self) -> Self {
        match (self, other) {
            (Trit::True, Trit::True) => Trit::True,
            (Trit::False, _) | (_, Trit::False) => Trit::False,
            _ => Trit::Maybe,
        }
    }
}

impl ops::BitOr for Trit {
    type Output = Self;
    fn bitor(self, other: Self) -> Self {
        match (self, other) {
            (Trit::True, _) | (_, Trit::True) => Trit::True,
            (Trit::False, Trit::False) => Trit::False,
            _ => Trit::Maybe,
        }
    }
}

impl Trit {
    fn imp(self, other: Self) -> Self {
        match self {
            Trit::True => other,
            Trit::Maybe => {
                if let Trit::True = other {
                    Trit::True
                } else {
                    Trit::Maybe
                }
            }
            Trit::False => Trit::True,
        }
    }

    fn eqv(self, other: Self) -> Self {
        match self {
            Trit::True => other,
            Trit::Maybe => Trit::Maybe,
            Trit::False => !other,
        }
    }
}

impl fmt::Display for Trit {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(
            f,
            "{}",
            match self {
                Trit::True => 'T',
                Trit::Maybe => 'M',
                Trit::False => 'F',
            }
        )
    }
}

static TRITS: [Trit; 3] = [Trit::True, Trit::Maybe, Trit::False];

fn main() {
    println!("not");
    println!("-------");
    for &t in &TRITS {
        println!(" {}  | {}", t, !t);
    }

    table("and", |a, b| a & b);
    table("or", |a, b| a | b);
    table("imp", |a, b| a.imp(b));
    table("eqv", |a, b| a.eqv(b));
}

fn table(title: &str, f: impl Fn(Trit, Trit) -> Trit) {
    println!();
    println!("{:3} | T  M  F", title);
    println!("-------------");
    for &t1 in &TRITS {
        print!(" {}  | ", t1);
        for &t2 in &TRITS {
            print!("{}  ", f(t1, t2));
        }
        println!();
    }
}
