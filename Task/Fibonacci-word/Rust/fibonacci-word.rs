struct Fib<T> {
    curr: T,
    next: T,
}

impl<T> Fib<T> {
    fn new(curr: T, next: T) -> Self {
        Fib { curr: curr, next: next, }
    }
}

impl Iterator for Fib<String>  {
    type Item = String;
    fn next(&mut self) -> Option<Self::Item> {
        let ret = self.curr.clone();
        self.curr = self.next.clone();
        self.next = format!("{}{}", ret, self.next);
        Some(ret)
    }
}

fn get_entropy(s: &[u8]) -> f64 {
    let mut entropy = 0.0;
    let mut histogram = [0.0; 256];

    for i in 0..s.len() {
        histogram.get_mut(s[i] as usize).map(|v| *v += 1.0);
    }

    for i in 0..256 {
        if histogram[i] > 0.0 {
            let ratio = histogram[i] / s.len() as f64;
            entropy -= ratio * ratio.log2();
        }
    }
    entropy
}

fn main() {
    let f = Fib::new("1".to_string(), "0".to_string());
        println!("{:10} {:10} {:10} {:60}", "N", "Length", "Entropy", "Word");
    for (i, s) in f.take(37).enumerate() {
        let word = if s.len() > 60 {"Too long"} else {&*s};
        println!("{:10} {:10} {:.10} {:60}", i + 1, s.len(), get_entropy(&s.bytes().collect::<Vec<_>>()), word);
    }
}
