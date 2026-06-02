import "std/string.zc"

fn main() {
    let letters = String::from("");
    for r in 'a'..= 'z' { letters.push_rune(r) };
    println "{letters.c_str()}";
}
