use std::cell::Cell;

fn a(k: i32, x1: &Fn() -> i32, x2: &Fn() -> i32, x3: &Fn() -> i32, x4: &Fn() -> i32, x5: &Fn() -> i32) -> i32 {
    let k1 = Cell::new(k);
    struct B<'a> { f: &'a Fn(&B) -> i32 }
    let b = B {
        f: &|b| {
            k1.set(k1.get() - 1);
            return a(k1.get(), &||(b.f)(b), x1, x2, x3, x4)
        }
    };
    let b = ||(b.f)(&b);
    return if k <= 0 {x4() + x5()} else {b()}
}

pub fn main() {
    println!("{}", a(10, &||1, &||-1, &||-1, &||1, &||0));
}
