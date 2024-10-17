use std::fmt;

enum Direction { RIGHT, UP, LEFT, DOWN }
use ulam::Direction::*;

/// Indicates whether an integer is a prime number or not.
fn is_prime(a: u32) -> bool {
    match a {
        2 => true,
        x if x <= 1 || x % 2 == 0 => false,
        _ => {
            let max = f64::sqrt(a as f64) as u32;
            let mut x =  3;
            while x <= max {
                if a % x == 0 { return false; }
                x += 2;
            }
            true
        }
    }
}

pub struct Ulam { u : Vec<Vec<String>> }

impl Ulam {
    /// Generates one `Ulam` object.
    pub fn new(n: u32, s: u32, c: char) -> Ulam {
        let mut spiral = vec![vec![String::new(); n as usize]; n as usize];
        let mut dir = RIGHT;
        let mut y = (n / 2) as usize;
        let mut x = if n % 2 == 0 { y - 1 } else { y }; // shift left for even n's
        for j in s..n * n + s {
            spiral[y][x] = if is_prime(j) {
                if c == '\0' { format!("{:4}", j) } else { format!("  {} ", c) }
            }
            else { String::from(" ---") };

            match dir {
                RIGHT => if x as u32 <= n - 1 && spiral[y - 1][x].is_empty() && j > s { dir = UP; },
                UP => if spiral[y][x - 1].is_empty() { dir = LEFT; },
                LEFT => if x == 0 || spiral[y + 1][x].is_empty() { dir = DOWN; },
                DOWN => if spiral[y][x + 1].is_empty() { dir = RIGHT; }
            };

            match dir { RIGHT => x += 1, UP => y -= 1, LEFT => x -= 1, DOWN => y += 1 };
        }
        Ulam { u: spiral }
    }
}

impl fmt::Display for Ulam {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        for row in &self.u {
            writeln!(f, "{}", format!("{:?}", row).replace("\"", "").replace(", ", ""));
        };
        writeln!(f, "")
    }
}
