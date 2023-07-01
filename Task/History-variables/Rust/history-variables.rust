#[derive(Clone, Debug)]
struct HVar<T> {
    history: Vec<T>,
    current: T,
}

impl<T> HVar<T> {
    fn new(val: T) -> Self {
        HVar {
            history: Vec::new(),
            current: val,
        }
    }

    fn get(&self) -> &T {
        &self.current
    }

    fn set(&mut self, val: T) {
        self.history.push(std::mem::replace(&mut self.current, val));
    }

    fn history(&self) -> (&[T], &T) {
        (&self.history, &self.current)
    }

    fn revert(&mut self) -> Option<T> {
        self.history
            .pop()
            .map(|val| std::mem::replace(&mut self.current, val))
    }
}

fn main() {
    let mut var = HVar::new(0);
    var.set(1);
    var.set(2);
    println!("{:?}", var.history());
    println!("{:?}", var.revert());
    println!("{:?}", var.revert());
    println!("{:?}", var.revert());
    println!("{:?}", var.get());
}
