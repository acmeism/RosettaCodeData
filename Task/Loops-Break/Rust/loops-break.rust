// cargo-deps: rand

extern crate rand;
use rand::{thread_rng, Rng};

fn main() {
    let mut rng = thread_rng();
    loop {
        let num = rng.gen_range(0, 20);
        if num == 10 {
            println!("{}", num);
            break;
        }
        println!("{}", rng.gen_range(0, 20));
    }
}
