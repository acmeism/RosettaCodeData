use num::integer::lcm;

fn main() {
    let answer = (1..=20).fold(1, |acc, x| lcm(acc, x));

    println!("{}", answer);
}
