import "std/string.zc"

fn main() {
    // C style null-terminated strings.
    let s = "";
    if s == NULL || strlen(s) == 0 {
        println "'s' is empty.";
    } else {
        println "'s' is not empty.";
    }

    // Zen C style growable Strings.
    let z = String::from("0");
    if z.length() == 0 {
        println "'z' is empty.";
    } else {
        println "'z' is not empty.";
    }
}
