#![allow(unused_variables)]
macro_rules! if2 {
    ($cond1: expr, $cond2: expr
        => $both:expr
        => $first: expr
        => $second:expr
        => $none:expr)
    => {
        match ($cond1, $cond2) {
            (true, true) => $both,
            (true, _   ) => $first,
            (_   , true) => $second,
            _            => $none
        }
    }
}

fn main() {
    let i = 1;
    let j = 2;
    if2!(i > j, i + j >= 3
        => {
            // code blocks and statements can go here also
            let k = i + j;
            println!("both were true")
        }
        => println!("the first was true")
        => println!("the second was true")
        => println!("neither were true")
    )
}
