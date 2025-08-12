use std::io;

struct Fractran {
    start: i32,
    limit: i32,
}

impl Fractran {
    fn new() -> Self {
        Fractran {
            start: 0,
            limit: 0,
        }
    }

    fn run(&mut self, program: &str, start: i32, limit: i32) {
        self.start = start;
        self.limit = limit;

        // Parse the program string into fraction pairs
        let fractions: Vec<(f64, f64)> = program
            .split_whitespace()
            .filter_map(|fraction_str| {
                if let Some(pos) = fraction_str.find('/') {
                    let numerator = fraction_str[..pos].parse::<f64>().ok()?;
                    let denominator = fraction_str[pos + 1..].parse::<f64>().ok()?;
                    Some((numerator, denominator))
                } else {
                    None
                }
            })
            .collect();

        self.exec(&fractions);
    }

    fn exec(&mut self, fractions: &[(f64, f64)]) {
        let mut count = 0;

        while count < self.limit {
            println!("{} : {}", count, self.start);
            count += 1;

            let mut found = false;

            for &(numerator, denominator) in fractions {
                let result = self.start as f64 * (numerator / denominator);

                // Check if result is a whole number
                if (result - result.floor()).abs() < f64::EPSILON {
                    self.start = result as i32;
                    found = true;
                    break;
                }
            }

            if !found {
                break;
            }
        }
    }
}

fn main() {
    let mut fractran = Fractran::new();
    fractran.run(
        "17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1",
        2,
        15
    );

    // Wait for user input (equivalent to cin.get())
    let mut input = String::new();
    io::stdin().read_line(&mut input).expect("Failed to read line");
}
