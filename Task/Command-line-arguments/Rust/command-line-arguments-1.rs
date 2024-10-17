use std::env;

fn main(){
    let args: Vec<_> = env::args().collect();
    println!("{:?}", args);
}
