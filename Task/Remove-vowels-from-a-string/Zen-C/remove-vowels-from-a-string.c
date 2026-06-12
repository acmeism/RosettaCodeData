import "std/string.zc"

fn remove_vowels(s: string) -> String {
    let res = String::from(s);
    let vowels = String::from("aeiouAEIOU");
    let len = res.utf8_len();
    for (let i: isize = len - 1; i >= 0; --i) {
        let c = res.utf8_get(i);
        if vowels.contains(c) { res.remove_rune_at(i); }
    }
    return res;
}

fn main() {
    let s = "The Zen C Programming Language";
    println "Input  : {s}";
    println "Output : {remove_vowels(s)}";
}
