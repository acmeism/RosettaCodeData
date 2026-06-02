import "std/string.zc"

fn reverse_str(s: string) -> String {
    let s2 = String::from(s);
    let r = s2.runes();
    r.reverse();
    return String::from_runes_vec(r);
}

fn main() {
    let words= ["asdf", "josé", "møøse", "was it a car or a cat I saw", "😀🚂🦊"];
    for word in words {
        let rev = reverse_str(word);
        println "{rev}";
    }
}
