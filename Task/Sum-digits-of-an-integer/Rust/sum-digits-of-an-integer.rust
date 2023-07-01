struct DigitIter(usize, usize);

impl Iterator for DigitIter {
    type Item = usize;
    fn next(&mut self) -> Option<Self::Item> {
        if self.0 == 0 {
            None
        } else {
            let ret = self.0 % self.1;
            self.0 /= self.1;
            Some(ret)
        }
    }
}

fn main() {
    println!("{}", DigitIter(1234,10).sum::<usize>());
}
