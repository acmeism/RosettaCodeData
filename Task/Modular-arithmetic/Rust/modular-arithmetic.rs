use std::fmt;
use std::ops::{Add, Mul};

// Generic function f that works with any type T that implements the required traits
fn f<T>(x: T) -> T
where
    T: Copy + Add<Output = T> + From<i32>,
    ModularInteger: From<T>,
    T: From<ModularInteger>,
{
    // Convert to ModularInteger to use the pow function, then convert back
    let mod_int = ModularInteger::from(x);
    let powered = mod_int.pow(100);
    T::from(powered + ModularInteger::from(x) + ModularInteger::from(T::from(1)))
}

// For the specific case of ModularInteger, we implement f directly
impl ModularInteger {
    fn f_specific(self) -> Self {
        self.pow(100) + self + ModularInteger::new(1, self.modulus)
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct ModularInteger {
    value: i32,
    modulus: i32,
}

impl ModularInteger {
    fn new(v: i32, m: i32) -> Self {
        ModularInteger {
            value: v.rem_euclid(m), // Use rem_euclid for proper modular arithmetic
            modulus: m,
        }
    }

    fn get_value(&self) -> i32 {
        self.value
    }

    fn get_modulus(&self) -> i32 {
        self.modulus
    }

    fn validate_op(&self, rhs: &ModularInteger) -> Result<(), String> {
        if self.modulus != rhs.modulus {
            Err("Left-hand modulus does not match right-hand modulus.".to_string())
        } else {
            Ok(())
        }
    }

    fn pow(&self, mut exp: i32) -> Self {
        if exp < 0 {
            panic!("Power must not be negative.");
        }

        let mut base = ModularInteger::new(1, self.modulus);
        let mut current = *self;

        // Use fast exponentiation algorithm
        while exp > 0 {
            if exp % 2 == 1 {
                base = base * current;
            }
            current = current * current;
            exp /= 2;
        }
        base
    }
}

// Implement Add trait for ModularInteger + ModularInteger
impl Add<ModularInteger> for ModularInteger {
    type Output = ModularInteger;

    fn add(self, rhs: ModularInteger) -> ModularInteger {
        self.validate_op(&rhs).expect("Modulus mismatch");
        ModularInteger::new(self.value + rhs.value, self.modulus)
    }
}

// Implement Add trait for ModularInteger + i32
impl Add<i32> for ModularInteger {
    type Output = ModularInteger;

    fn add(self, rhs: i32) -> ModularInteger {
        ModularInteger::new(self.value + rhs, self.modulus)
    }
}

// Implement Mul trait for ModularInteger * ModularInteger
impl Mul<ModularInteger> for ModularInteger {
    type Output = ModularInteger;

    fn mul(self, rhs: ModularInteger) -> ModularInteger {
        self.validate_op(&rhs).expect("Modulus mismatch");
        ModularInteger::new(self.value * rhs.value, self.modulus)
    }
}

// Implement Display trait for pretty printing
impl fmt::Display for ModularInteger {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "ModularInteger({}, {})", self.value, self.modulus)
    }
}

// Conversion traits for the generic function
impl From<i32> for ModularInteger {
    fn from(value: i32) -> Self {
        ModularInteger::new(value, 13) // Default modulus for demonstration
    }
}

impl From<ModularInteger> for i32 {
    fn from(mod_int: ModularInteger) -> Self {
        mod_int.value
    }
}

fn main() {
    let input = ModularInteger::new(10, 13);
    let output = input.f_specific(); // Using the specific implementation for ModularInteger
    println!("f({}) = {}", input, output);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_modular_integer_creation() {
        let mi = ModularInteger::new(15, 13);
        assert_eq!(mi.get_value(), 2);
        assert_eq!(mi.get_modulus(), 13);
    }

    #[test]
    fn test_addition() {
        let mi1 = ModularInteger::new(10, 13);
        let mi2 = ModularInteger::new(5, 13);
        let result = mi1 + mi2;
        assert_eq!(result.get_value(), 2); // (10 + 5) % 13 = 2
    }

    #[test]
    fn test_multiplication() {
        let mi1 = ModularInteger::new(10, 13);
        let mi2 = ModularInteger::new(5, 13);
        let result = mi1 * mi2;
        assert_eq!(result.get_value(), 11); // (10 * 5) % 13 = 11
    }

    #[test]
    fn test_power() {
        let mi = ModularInteger::new(2, 13);
        let result = mi.pow(3);
        assert_eq!(result.get_value(), 8); // 2^3 = 8
    }

    #[test]
    #[should_panic(expected = "Modulus mismatch")]
    fn test_mismatched_modulus() {
        let mi1 = ModularInteger::new(10, 13);
        let mi2 = ModularInteger::new(5, 17);
        let _ = mi1 + mi2;
    }

    #[test]
    #[should_panic(expected = "Power must not be negative")]
    fn test_negative_power() {
        let mi = ModularInteger::new(2, 13);
        mi.pow(-1);
    }
}
