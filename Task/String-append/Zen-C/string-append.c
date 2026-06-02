import "std/string.zc"

fn main() {
    let s = String::from("Hello, ");
    s.append_c("world!");
    println "{s}";
}
