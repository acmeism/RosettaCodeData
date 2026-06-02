import "std/string.zc"

fn reverse_str(s: string) -> String {
    let s2 = String::from(s);
    let r = s2.runes();
    r.reverse();
    return String::from_runes_vec(r);
}

fn is_pal(s: string) -> bool {
    if strlen(s) > 0 {
        let rev = reverse_str(s);
        let ss = String::from(s);
        return rev == &ss;
    }
    return true;
}

fn main() {
    println "Are the following palindromes?";
    let phrases = ["rotor", "rosetta", "step on no pets", "été", "zenc", "🦊😀🦊"];
    for phrase in phrases {
        println "  {phrase} => {is_pal(phrase)}";
    }
}
