import "std/string.zc"

fn main() {
    let s = String::from("αβγδεζηθ");
    let l = s.utf8_len();
    let n = 2;
    let m = 3;
    let kc = 'δ';  // known character
    let ks = String::from("δε");  // known string

    // for reference
    println "Index of characters:  01234567";
    println "Complete string:      {s}";

    // starting from n characters in and of m length
    let ss1 = s.utf8_substr(n, m);
    println "Start {n}, length {m}:    {ss1}";

    // starting from n characters in, up to the end of the string
    let ss2 = s.utf8_substr(n, l - n);
    println "Start {n}, to end:      {ss2}";

    // whole string minus last character
    let ss3 = s.utf8_substr(0, l - 1);
    println "All but last:         {ss3}";

    // starting from a known character within the string and of m length
    let dx = -1;
    for i, c in s {
        if c == kc {
            dx = i;
            break;
        }
    }
    if dx >= 0 {
        let ss4 = s.utf8_substr(dx, m);
        let kcs = String::from_rune(kc);
        println "Start '{kcs}', length {m}:  {ss4}";
    }

    // starting from a known substring within the string and of m length
    let sx = -1;
    let first  = ks.utf8_get(0);
    let second = ks.utf8_get(1);
    for i in 0..(s.utf8_len() - 1) {
        if s.utf8_get(i) == first && s.utf8_get(i + 1) == second {
            sx = i;
            break;
        }
    }
    if (sx >= 0) {
        let ss5 = s.utf8_substr(sx, m);
        println "Start '{ks}', length {m}: {ss5}";
    }
}
