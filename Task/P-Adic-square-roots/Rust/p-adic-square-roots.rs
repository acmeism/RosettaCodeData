use std::cmp::Ordering;
use std::fmt;

#[derive(Clone)]
struct PAdicSquareRoot {
    prime: u32,
    precision: u32,
    digits: Vec<u32>,
    order: i32,
}

impl PAdicSquareRoot {
    // Create a PAdicSquareRoot number, with p = 'prime', from the given rational 'numerator' / 'denominator'.
    fn new(prime: u32, precision: u32, mut numerator: i32, mut denominator: i32) -> Result<Self, String> {
        if denominator == 0 {
            return Err("Denominator cannot be zero".to_string());
        }

        let digits_size = precision + 5;
        let mut order = 0;
        let mut digits = vec![0; digits_size as usize];

        // Process rational zero
        if numerator == 0 {
            return Ok(Self {
                prime,
                precision,
                digits,
                order: 1000, // ORDER_MAX from original code
            });
        }

        // Remove multiples of 'prime' and adjust the order of the PAdicSquareRoot number accordingly
        while Self::modulo(numerator as i64, prime as i64) == 0 {
            numerator /= prime as i32;
            order += 1;
        }

        while Self::modulo(denominator as i64, prime as i64) == 0 {
            denominator /= prime as i32;
            order -= 1;
        }

        if (order & 1) != 0 {
            return Err(format!("Number does not have a square root in {}-adic", prime));
        }
        order >>= 1;

        let mut result = Self {
            prime,
            precision,
            digits: Vec::with_capacity(digits_size as usize),
            order,
        };

        if prime == 2 {
            result.square_root_even_prime(numerator, denominator)?;
        } else {
            result.square_root_odd_prime(numerator, denominator)?;
        }

        // Ensure we have the right number of digits
        while result.digits.len() < digits_size as usize {
            result.digits.push(0);
        }
        result.digits.truncate(digits_size as usize);

        Ok(result)
    }

    // Create a PAdicSquareRoot directly from a vector of digits
    fn from_digits(prime: u32, precision: u32, digits: Vec<u32>, order: i32) -> Self {
        Self {
            prime,
            precision,
            digits,
            order,
        }
    }

    // Return the additive inverse of this PAdicSquareRoot number
    fn negate(&self) -> Self {
        if self.digits.is_empty() {
            return self.clone();
        }

        let mut negated = self.digits.clone();
        Self::negate_digits(&mut negated, self.prime);

        Self::from_digits(self.prime, self.precision, negated, self.order)
    }

    // Return the product of this PAdicSquareRoot number and another PAdicSquareRoot number
    fn multiply(&self, other: &Self) -> Result<Self, String> {
        if self.prime != other.prime {
            return Err("Cannot multiply p-adic's with different primes".to_string());
        }

        if self.digits.is_empty() || other.digits.is_empty() {
            return Self::new(self.prime, self.precision, 0, 1);
        }

        let product_digits = Self::multiply_digits(&self.digits, &other.digits, self.prime, (self.precision + 5) as usize);
        Ok(Self::from_digits(
            self.prime,
            self.precision,
            product_digits,
            self.order + other.order,
        ))
    }

    // Return a string representation of this PAdicSquareRoot as a rational number
    fn convert_to_rational(&self) -> Result<String, String> {
        if self.digits.is_empty() {
            return Ok("0 / 1".to_string());
        }

        // Lagrange lattice basis reduction in two dimensions
        let mut series_sum: i64 = self.digits[0] as i64;
        let mut maximum_prime: i64 = 1;

        for i in 1..self.precision {
            maximum_prime *= self.prime as i64;
            series_sum += (self.digits[i as usize] as i64) * maximum_prime;
        }

        let mut one = vec![maximum_prime, series_sum];
        let mut two = vec![0, 1];

        let mut previous_norm = series_sum * series_sum + 1;
        let mut current_norm = previous_norm + 1;
        let mut i = 0;
        let mut j = 1;

        while previous_norm < current_norm {
            let numerator = one[i] * one[j] + two[i] * two[j];
            let denominator = previous_norm;
            current_norm = ((numerator as f64) / (denominator as f64) + 0.5).floor() as i64;
            one[i] -= current_norm * one[j];
            two[i] -= current_norm * two[j];

            current_norm = previous_norm;
            previous_norm = one[i] * one[i] + two[i] * two[i];

            if previous_norm < current_norm {
                std::mem::swap(&mut i, &mut j);
            }
        }

        let mut x = one[j];
        let mut y = two[j];
        if y < 0 {
            y = -y;
            x = -x;
        }

        if (one[i] * y - x * two[i]).abs() != maximum_prime {
            return Err("Rational reconstruction failed.".to_string());
        }

        for _ in self.order..0 {
            y *= self.prime as i64;
        }

        for _ in 0..self.order {
            x *= self.prime as i64;
        }

        Ok(format!("{} / {}", x, y))
    }

    // Create a 2-adic number which is the square root of the rational 'numerator' / 'denominator'
    fn square_root_even_prime(&mut self, numerator: i32, denominator: i32) -> Result<(), String> {
        if Self::modulo((numerator as i64) * (denominator as i64), 8) != 1 {
            return Err("Number does not have a square root in 2-adic".to_string());
        }

        // First digit
        let mut sum: i64 = 1;
        self.digits.push(1);

        // Further digits
        let digits_size = self.precision + 5;
        while self.digits.len() < digits_size as usize {
            let factor = (denominator as i64) * sum * sum - (numerator as i64);
            let mut valuation = 0;
            let mut factor_temp = factor;
            while Self::modulo(factor_temp, 2) == 0 {
                factor_temp /= 2;
                valuation += 1;
            }

            sum += 2i64.pow(valuation - 1);

            while self.digits.len() < (valuation - 1) as usize {
                self.digits.push(0);
            }
            self.digits.push(1);
        }

        Ok(())
    }

    // Create a p-adic number, with an odd prime number, p = 'prime',
    // which is the p-adic square root of the given rational 'numerator' / 'denominator'
    fn square_root_odd_prime(&mut self, numerator: i32, denominator: i32) -> Result<(), String> {
        // First digit
        let mut first_digit = 0;
        for i in 1..self.prime {
            if Self::modulo(
                (denominator as i64) * (i as i64) * (i as i64) - (numerator as i64),
                self.prime as i64,
            ) == 0
            {
                first_digit = i;
                break;
            }
        }

        if first_digit == 0 {
            return Err(format!(
                "Number does not have a square root in {}-adic",
                self.prime
            ));
        }

        self.digits.push(first_digit);

        // Further digits
        let coefficient = Self::modulo_inverse(
            Self::modulo(2 * (denominator as i64) * (first_digit as i64), self.prime as i64) as u32,
            self.prime,
        );

        let mut sum: i64 = first_digit as i64;
        let digits_size = self.precision + 5;

        for i in 2..digits_size {
            let mut next_sum = sum - ((coefficient as i64) * ((denominator as i64) * sum * sum - (numerator as i64)));
            next_sum = Self::modulo(next_sum, (self.prime as i64).pow(i));
            next_sum -= sum;
            sum += next_sum;

            let digit = (next_sum / (self.prime as i64).pow(i - 1)) as u32;
            self.digits.push(digit);
        }

        Ok(())
    }

    // Transform the given vector of digits representing a p-adic number
    // into a vector which represents the negation of the p-adic number
    fn negate_digits(numbers: &mut Vec<u32>, prime: u32) {
        if !numbers.is_empty() {
            numbers[0] = Self::modulo(prime as i64 - numbers[0] as i64, prime as i64) as u32;
            for i in 1..numbers.len() {
                numbers[i] = prime - 1 - numbers[i];
            }
        }
    }

    // Return the list obtained by multiplying the digits of the given two lists
    fn multiply_digits(one: &[u32], two: &[u32], prime: u32, max_size: usize) -> Vec<u32> {
        let mut product = vec![0; one.len() + two.len()];

        for b in 0..two.len() {
            let mut carry = 0;
            for a in 0..one.len() {
                product[a + b] += one[a] * two[b] + carry;
                carry = product[a + b] / prime;
                product[a + b] %= prime;
            }
            if b + one.len() < product.len() {
                product[b + one.len()] = carry;
            }
        }

        // Truncate to max_size
        product.truncate(max_size);
        product
    }

    // Return the multiplicative inverse of the given number modulo 'prime'
    fn modulo_inverse(number: u32, prime: u32) -> u32 {
        let mut inverse: u32 = 1;
        while Self::modulo((inverse as i64) * (number as i64), prime as i64) != 1 {
            inverse += 1;
        }
        inverse
    }

    // Return the given number modulo 'prime' in the range 0..'prime' - 1
    fn modulo(number: i64, modulus: i64) -> i64 {
        let div = number % modulus;
        if div >= 0 {
            div
        } else {
            div + modulus
        }
    }

    // Generate string representation of this PAdicSquareRoot
    fn to_string(&self) -> String {
        let mut numbers = self.digits.clone();

        // Ensure we have the right number of digits
        while numbers.len() < (self.precision + 5) as usize {
            numbers.push(0);
        }

        let mut result = String::new();
        for i in (0..numbers.len()).rev() {
            result.push_str(&numbers[i].to_string());
        }

        if self.order >= 0 {
            for _ in 0..self.order {
                result.push('0');
            }
            result.push_str(".0");
        } else {
            let insert_pos = result.len() as i32 + self.order;
            if insert_pos >= 0 {
                result.insert(insert_pos as usize, '.');
            } else {
                // If we need to insert before the start, pad with zeros
                let zeros_needed = -insert_pos;
                result = "0.".to_string() + &"0".repeat(zeros_needed as usize) + &result;
            }

            // Remove trailing zeros
            while result.ends_with('0') {
                result.pop();
            }
        }

        // Return with ellipsis at the beginning
        let start_pos = if result.len() > self.precision as usize + 1 {
            result.len() - self.precision as usize - 1
        } else {
            0
        };
        format!(" ...{}", &result[start_pos..])
    }
}

fn main() {
    let tests = vec![
        vec![2, 20, 497, 10496],
        vec![5, 14, 86, 25],
        vec![7, 10, -19, 1],
    ];

    for test in tests {
        println!(
            "Number: {} / {} in {}-adic",
            test[2], test[3], test[0]
        );

        match PAdicSquareRoot::new(test[0] as u32, test[1] as u32, test[2], test[3]) {
            Ok(square_root) => {
                println!("The two square roots are:");
                println!("    {}", square_root.to_string());
                println!("    {}", square_root.negate().to_string());

                match square_root.multiply(&square_root) {
                    Ok(square) => {
                        println!("The p-adic value is {}", square.to_string());
                        match square.convert_to_rational() {
                            Ok(rational) => println!("The rational value is {}", rational),
                            Err(e) => println!("Error converting to rational: {}", e),
                        }
                    },
                    Err(e) => println!("Error calculating square: {}", e),
                }
            },
            Err(e) => println!("Error: {}", e),
        }
        println!();
    }
}
