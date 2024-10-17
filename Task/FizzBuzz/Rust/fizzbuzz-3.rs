use std::fmt::Write;

fn fizzbuzz() -> String {
    (1..=100).fold(String::new(), |mut output, x| {
        let fizz = if x % 3 == 0 { "fizz" } else { "" };
        let buzz = if x % 5 == 0 { "buzz" } else { "" };
        if fizz.len() + buzz.len() != 0 {
            output + fizz + buzz + "\n"
        } else {
            write!(&mut output, "{}", x).unwrap();
            output + "\n"
        }
    })
}

fn main() {
    println!("{}", fizzbuzz());
}
