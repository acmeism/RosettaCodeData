use std::fmt;

#[derive(Debug)]
struct MiddleSquare {
    state: u64,
    div: u64,
    modulo: u64,
}

impl MiddleSquare {
    fn new(start: u64, length: u64) -> Result<Self, &'static str> {
        if length % 2 != 0 {
            return Err("length must be even");
        }

        let mut div = 1;
        let mut modulo = 1;

        for _ in 0..(length / 2) {
            div *= 10;
        }

        for _ in 0..length {
            modulo *= 10;
        }

        Ok(MiddleSquare {
            state: start % modulo,
            div,
            modulo,
        })
    }

    fn next(&mut self) -> u64 {
        self.state = (self.state * self.state / self.div) % self.modulo;
        self.state
    }
}

impl fmt::Display for MiddleSquare {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "MiddleSquare {{ state: {}, div: {}, modulo: {} }}", self.state, self.div, self.modulo)
    }
}

fn main() -> Result<(), &'static str> {
    let mut msq = MiddleSquare::new(675248, 6)?;

    for _ in 0..5 {
        println!("{}", msq.next());
    }

    Ok(())
}
