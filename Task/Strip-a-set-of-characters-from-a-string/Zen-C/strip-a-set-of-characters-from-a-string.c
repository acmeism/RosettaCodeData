import "std/string.zc"

fn strip_chars(s: String, t: String) -> String {
    let r = String::from("");
    for c in s {
        if !t.contains(c) { r.push_rune(c); }
    }
    return r;
}

fn main() {
    let s = String::from("She was a soul stripper. She took my heart!");
    let t = String::from("aei");
    let r = strip_chars(s, t);
    println "{r}";
}
