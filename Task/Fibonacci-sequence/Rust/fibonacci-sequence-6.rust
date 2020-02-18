use std::mem;

struct Fib {
    prev: usize,
    curr: usize,
}

impl Fib {
    fn new() -> Self {
        Fib {prev: 0, curr: 1}
    }
}

impl Iterator for Fib {
    type Item = usize;
    fn next(&mut self) -> Option<Self::Item>{
        mem::swap(&mut self.curr, &mut self.prev);
        self.curr.checked_add(self.prev).map(|n| {
            self.curr = n;
            n
        })
    }
}

fn main() {
    for num in Fib::new() {
        println!("{}", num);
    }
}
