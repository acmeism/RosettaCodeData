import "std/env.zc"

fn main() {
    let shell = Env::get_dup("SHELL").unwrap();
    println "{shell}";
}
