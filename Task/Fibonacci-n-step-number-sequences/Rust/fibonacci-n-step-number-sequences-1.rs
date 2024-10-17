struct GenFibonacci {
    buf:    Vec<u64>,
    sum:    u64,
    idx:    usize,
}

impl Iterator for GenFibonacci {
    type Item = u64;
    fn next(&mut self) -> Option<u64> {
        let result = Some(self.sum);
        self.sum -= self.buf[self.idx];
        self.buf[self.idx] += self.sum;
        self.sum += self.buf[self.idx];
        self.idx = (self.idx + 1) % self.buf.len();
        result
    }
}

fn print(buf: Vec<u64>, len: usize) {
    let mut sum = 0;
    for &elt in buf.iter() { sum += elt; print!("\t{}", elt); }
    let iter = GenFibonacci { buf: buf, sum: sum, idx: 0 };
    for x in iter.take(len) {
        print!("\t{}", x);
    }
}


fn main() {
    print!("Fib2:");
    print(vec![1,1], 10 - 2);

    print!("\nFib3:");
    print(vec![1,1,2], 10 - 3);

    print!("\nFib4:");
    print(vec![1,1,2,4], 10 - 4);

    print!("\nLucas:");
    print(vec![2,1], 10 - 2);
}
