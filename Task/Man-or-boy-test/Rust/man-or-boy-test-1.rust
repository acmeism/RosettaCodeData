use std::cell::Cell;

trait Arg {
    fn run(&self) -> i32;
}

impl Arg for i32 {
    fn run(&self) -> i32 { *self }
}

struct B<'a> {
    k: &'a Cell<i32>,
    x1: &'a Arg,
    x2: &'a Arg,
    x3: &'a Arg,
    x4: &'a Arg,
}

impl<'a> Arg for B<'a> {
    fn run(&self) -> i32 {
        self.k.set(self.k.get() - 1);
        a(self.k.get(), self, self.x1, self.x2, self.x3, self.x4)
    }
}

fn a(k: i32, x1: &Arg, x2: &Arg, x3: &Arg, x4: &Arg, x5: &Arg) -> i32 {
    if k <= 0 {
        x4.run() + x5.run()
    } else {
        B{
            k: &Cell::new(k),
            x1, x2, x3, x4
        }.run()
    }
}

pub fn main() {
    println!("{}", a(10, &1, &-1, &-1, &1, &0));
}
