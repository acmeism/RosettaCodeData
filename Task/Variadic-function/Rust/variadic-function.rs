// 20220106 Rust programming solution

macro_rules! print_all {
   ($($args:expr),*) => { $( println!("{}", $args); )* }
}

fn main() {
   print_all!("Rosetta", "Code", "Is", "Awesome!");
}
