import "ctype.h"

fn is_upper_vowel(c: char) -> bool {
    return c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U';
}

fn sedol_checkdigit(s: const string) -> int {
    if strlen(s) != 6 { return -1; }
    let weights: int[6] = [1, 3, 1, 7, 3, 9];
    let sum = 0;
    for i in 0..=5 {
        let c = s[i];
        if !isupper(c) && !isdigit(c) { return -1; }
        if is_upper_vowel(c) { return -1; }
        let j = (c <= '9') ? c - '0' : c - 'A' + 10;
        sum += j * weights[i];
    }
    return (10 - sum % 10) % 10;
}

fn main() {
    let tests: const string[12] = [
        "710889",
        "B0YBKJ",
        "406566",
        "B0YBLH",
        "228276",
        "B0YBKL",
        "557910",
        "B0YBKR",
        "585284",
        "B0YBKT",
        "B00030",
        "I23456"
    ];

    for t in tests {
        let cd = sedol_checkdigit(t);
        if cd >= 0 {
            println "{t} -> {t}{cd}";
        } else {
            println "{t} -> not valid";
        }
    }
}
