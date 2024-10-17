trait Bar {
    fn run(self);
}

impl Bar for usize {
    fn run(self) {
        print!("{};", self);
    }
}

fn main() {
    repeat(Bar::run, 6);
}
