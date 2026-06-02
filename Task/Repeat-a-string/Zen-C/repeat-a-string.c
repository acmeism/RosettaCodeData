import "std/string.zc"

fn main() {
    let s = String::new("");
    for _ in 0..5 { s.append_c("ha"); }
    println "{s}";
}
