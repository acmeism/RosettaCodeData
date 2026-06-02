import "std/string.zc"

fn main() {
    let s = "Beyoncé";
    let a = String::from(s);
    let l = a.utf8_len();
    let b = a.utf8_substr(1, l - 1);
    let c = a.utf8_substr(0, l - 1);
    let d = a.utf8_substr(1, l - 2);
    let e: String[4] = [a, b, c, d];
    for i in 0..e.len { println "{e[i]}"; }
}
