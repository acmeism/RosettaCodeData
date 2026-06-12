use std::fmt;

#[derive(Clone, Copy)]
struct Fraction {
    numer: u32,
    denom: u32,
}

impl fmt::Display for Fraction {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}/{}", self.numer, self.denom)
    }
}

fn print_vector<T: fmt::Display>(vec: &[T]) {
    print!("[");
    for (i, item) in vec.iter().enumerate() {
        if i > 0 {
            print!(", ");
        }
        print!("{}", item);
    }
    print!("]");
}

fn convergents(x: f64, size: usize) -> Vec<String> {
    let mut components = Vec::new();
    let mut x = x;
    let mut fraction_part = 1.0;

    for _ in 0..size {
        if fraction_part < 0.000_000_001 {
            break;
        }

        let int_part = x as u32;
        fraction_part = x - int_part as f64;
        components.push(int_part);

        if fraction_part > 0.0 {
            x = 1.0 / fraction_part;
        }
    }

    let mut result = Vec::new();
    let mut a = Fraction { numer: 0, denom: 1 };
    let mut b = Fraction { numer: 1, denom: 0 };

    for component in components {
        let a_copy = a;
        a = b;
        b = Fraction {
            numer: a_copy.numer + component * b.numer,
            denom: a_copy.denom + component * b.denom,
        };
        result.push(format!("{}/{}", b.numer, b.denom));
    }

    result
}

struct Test {
    description: &'static str,
    value: f64,
}

fn main() {
    let tests = vec![
        Test {
            description: "415/93",
            value: 415.0 / 93.0,
        },
        Test {
            description: "649/200",
            value: 649.0 / 200.0,
        },
        Test {
            description: "Square root of 2",
            value: 2.0_f64.sqrt(),
        },
        Test {
            description: "Square root of 5",
            value: 5.0_f64.sqrt(),
        },
        Test {
            description: "Golden ratio",
            value: (5.0_f64.sqrt() + 1.0) / 2.0,
        },
    ];

    println!("The continued fraction convergents for the following (maximum 8 terms) are:");
    for test in &tests {
        print!("{:>20} => ", test.description);
        let convergents_result = convergents(test.value, 8);
        print_vector(&convergents_result);
        println!();
    }
}
