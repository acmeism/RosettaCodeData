// rustc 1.26.0 or later

use std::ops::Add;

fn foo<Num>(n: Num) -> impl FnMut(Num) -> Num
        where Num: Add<Output=Num> + Copy + 'static {
    let mut acc = n;
    move |i: Num| {
        acc = acc + i;
        acc
    }
}

fn main() {
    let mut x = foo(1.);
    x(5.);
    foo(3.);
    println!("{}", x(2.3));
}
