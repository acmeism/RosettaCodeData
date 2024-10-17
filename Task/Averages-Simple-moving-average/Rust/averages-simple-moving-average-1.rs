struct SimpleMovingAverage {
    period: usize,
    numbers: Vec<usize>
}

impl SimpleMovingAverage {
    fn new(p: usize) -> SimpleMovingAverage {
        SimpleMovingAverage {
            period: p,
            numbers: Vec::new()
        }
    }

    fn add_number(&mut self, number: usize) -> f64 {
        self.numbers.push(number);

        if self.numbers.len() > self.period {
            self.numbers.remove(0);
        }

        if self.numbers.is_empty() {
            return 0f64;
        }else {
            let sum = self.numbers.iter().fold(0, |acc, x| acc+x);
            return sum as f64 / self.numbers.len() as f64;
        }
    }
}

fn main() {
    for period in [3, 5].iter() {
        println!("Moving average with period {}", period);

        let mut sma = SimpleMovingAverage::new(*period);
        for i in [1, 2, 3, 4, 5, 5, 4, 3, 2, 1].iter() {
            println!("Number: {} | Average: {}", i, sma.add_number(*i));
        }
    }
}
