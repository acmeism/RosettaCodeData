use std::fmt;

fn gcd(mut a: u64, mut b: u64) -> u64 {
    while b != 0 {
        let temp = b;
        b = a % b;
        a = temp;
    }
    a
}

#[derive(Debug, Clone)]
struct Rational {
    numerator: u64,
    denominator: u64,
}

impl Rational {
    fn new(numerator: u64, denominator: u64) -> Self {
        let gcd_val = gcd(numerator, denominator);
        Self {
            numerator: numerator / gcd_val,
            denominator: denominator / gcd_val,
        }
    }

    fn from_integer(value: u64) -> Self {
        Self {
            numerator: value,
            denominator: 1,
        }
    }

    fn from_decimal(decimal: &str) -> Result<Self, Box<dyn std::error::Error>> {
        let dot_index = decimal.find('.')
            .ok_or("Invalid decimal format: no decimal point found")?;

        let decimal_places = decimal.len() - 1 - dot_index;

        let integer_part = &decimal[..dot_index];
        let fractional_part = &decimal[dot_index + 1..];
        let combined = format!("{}{}", integer_part, fractional_part);

        let numerator = combined.parse::<u64>()?;
        let denominator = 10_u64.pow(decimal_places as u32);

        Ok(Self::new(numerator, denominator))
    }

    fn to_decimal(&self, decimal_places: u32) -> String {
        let mut result = String::new();
        let mut numer = self.numerator;
        let denom = self.denominator;
        let mut quotient = numer / denom;

        for i in 0..=decimal_places {
            result.push_str(&quotient.to_string());
            numer -= denom * quotient;

            if numer == 0 {
                break;
            }

            numer *= 10;
            quotient = numer / denom;

            if i == 0 {
                result.push('.');
            }
        }

        result
    }

    fn equals(&self, other: &Rational) -> bool {
        self.numerator == other.numerator && self.denominator == other.denominator
    }

    fn add(&self, other: &Rational) -> Rational {
        let numer = (self.numerator * other.denominator) + (self.denominator * other.numerator);
        let denom = self.denominator * other.denominator;
        Rational::new(numer, denom)
    }

    fn subtract(&self, other: &Rational) -> Rational {
        let numer = (self.numerator * other.denominator) - (self.denominator * other.numerator);
        let denom = self.denominator * other.denominator;
        Rational::new(numer, denom)
    }

    fn multiply(&self, other: &Rational) -> Rational {
        Rational::new(
            self.numerator * other.numerator,
            self.denominator * other.denominator,
        )
    }

    fn inverse(&self) -> Rational {
        Rational::new(self.denominator, self.numerator)
    }

    fn ceiling(&self) -> i64 {
        if self.numerator % self.denominator == 0 {
            (self.numerator / self.denominator) as i64
        } else {
            (self.numerator / self.denominator + 1) as i64
        }
    }
}

impl fmt::Display for Rational {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}/{}", self.numerator, self.denominator)
    }
}

const RATIONAL_ZERO: Rational = Rational { numerator: 0, denominator: 1 };
const RATIONAL_ONE: Rational = Rational { numerator: 1, denominator: 1 };

fn to_engel(decimal: &str) -> Result<Vec<u64>, Box<dyn std::error::Error>> {
    let mut engel = Vec::new();
    let mut rational = Rational::from_decimal(decimal)?;

    while !rational.equals(&RATIONAL_ZERO) {
        let term = rational.inverse().ceiling();
        engel.push(term as u64);
        rational = rational.multiply(&Rational::from_integer(term as u64)).subtract(&RATIONAL_ONE);
    }

    Ok(engel)
}

fn from_engel(engel: &[u64]) -> Rational {
    let mut sum = RATIONAL_ZERO.clone();
    let mut product = RATIONAL_ONE.clone();

    for &element in engel {
        let rational = Rational::from_integer(element).inverse();
        product = product.multiply(&rational);
        sum = sum.add(&product);
    }

    sum
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let rationals = vec![
        "3.14159265358979",
        "2.71828182845904",
        "1.414213562373095",
    ];

    for rational_str in rationals {
        let engel = to_engel(rational_str)?;

        println!("Rational number : {}", rational_str);
        print!("Engel expansion : ");
        for element in &engel {
            print!("{} ", element);
        }
        println!();
        println!("Number of terms : {}", engel.len());

        // Due to integer overflow,
        // Rust can only reconstruct the decimal numbers to a limited number of decimal places.

        let decimal_places = rational_str.len() - rational_str.find('.').unwrap_or(0);
        let reduced_engel: Vec<u64> = engel.iter().take(9).copied().collect();

        println!(
            "Back to rational: {}",
            from_engel(&reduced_engel).to_decimal(decimal_places as u32 / 2)
        );
        println!();
    }

    Ok(())
}
