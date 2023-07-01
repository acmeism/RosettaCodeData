use std::env;

fn main() {
    println!("{:?}", env::var("HOME"));
    println!();
    for (k, v) in env::vars().filter(|(k, _)| k.starts_with('P')) {
        println!("{}: {}", k, v);
    }
}
