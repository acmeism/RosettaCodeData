use std::borrow::Cow;

fn main() {
    (1..=100)
        .map(|n| match (n % 3, n % 5) {
            (0, 0) => "FizzBuzz".into(),
            (0, _) => "Fizz".into(),
            (_, 0) => "Buzz".into(),
            _ => Cow::from(n.to_string()),
        })
        .for_each(|n| println!("{:?}", n));
}
