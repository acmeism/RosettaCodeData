use std::collections::BTreeMap;
use std::fmt::{self, Write};
use std::io::{self, Stdin};

#[derive(Debug, PartialEq)]
pub struct FizzBuzz {
    end: usize,
    factors: Factors,
}

impl FizzBuzz {
    fn from_reader(rdr: &Stdin) -> Result<FizzBuzz, Box<dyn std::error::Error>> {
        let mut line = String::new();
        rdr.read_line(&mut line)?;

        let end = line.trim().parse::<usize>()?;

        let mut factors = Factors::new();

        loop {
            let mut line = String::new();
            rdr.read_line(&mut line)?;

            if line.trim().is_empty() { break; }

            let mut split = line.trim().splitn(2, ' ');

            let factor = match split.next() {
                Some(f) => f.parse::<usize>()?,
                None => break,
            };

            let phrase = match split.next() {
                Some(p) => p,
                None => break,
            };

            factors.insert(factor, phrase.to_string());
        }

        Ok(FizzBuzz { end, factors })
    }
}

impl fmt::Display for FizzBuzz {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        for n in 1..=self.end {
            let mut had_factor = false;

            // check for factors
            for (factor, phrase) in self.factors.iter() {
                if n % factor == 0 {
                    f.write_str(&phrase)?;
                    had_factor = true;
                }
            }

            if !had_factor {
                f.write_str(n.to_string().as_str())?;
            }
            f.write_char('\n')?;
        }
        Ok(())
    }
}

type Factors = BTreeMap<usize, String>;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = io::stdin();

    let fizz_buzz = FizzBuzz::from_reader(&input)?;

    println!("{}", fizz_buzz);

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn fizz_buzz_prints_expected_format() {
        let expected_factors = {
            let mut map = Factors::new();
            map.insert(3, "Fizz".to_string());
            map.insert(5, "Buzz".to_string());
            map.insert(7, "Baxx".to_string());
            map
        };

        let expected_end = 20;

        let fizz_buzz = FizzBuzz {
            end: expected_end,
            factors: expected_factors,
        };

        let expected = r#"1
2
Fizz
4
Buzz
Fizz
Baxx
8
Fizz
Buzz
11
Fizz
13
Baxx
FizzBuzz
16
17
Fizz
19
Buzz
"#;
        let printed = format!("{}", fizz_buzz);

        assert_eq!(expected, &printed);
    }
}
