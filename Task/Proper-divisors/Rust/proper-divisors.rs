trait ProperDivisors {
    fn proper_divisors(&self) -> Option<Vec<u64>>;
}

impl ProperDivisors for u64 {
    fn proper_divisors(&self) -> Option<Vec<u64>> {
        if self.le(&1) {
            return None;
        }
        let mut divisors: Vec<u64> = Vec::new();

        for i in 1..*self {
            if *self % i == 0 {
                divisors.push(i);
            }
        }
        Option::from(divisors)
    }
}

fn main() {
    for i in 1..11 {
        println!("Proper divisors of {:2}: {:?}", i,
                 i.proper_divisors().unwrap_or(vec![]));
    }

    let mut most_idx: u64 = 0;
    let mut most_divisors: Vec<u64> = Vec::new();
    for i in 1..20_001 {
        let divs = i.proper_divisors().unwrap_or(vec![]);
        if divs.len() > most_divisors.len() {
            most_divisors = divs;
            most_idx = i;
        }
    }
    println!("In 1 to 20000, {} has the most proper divisors at {}", most_idx,
             most_divisors.len());
}
