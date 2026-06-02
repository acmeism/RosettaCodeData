fn middle3(n: int) {
    let nn = n >= 0 ? n : -n;
    let s = "{nn}";
    let c = strlen(s);
    print "{n:9d} -> ";
    if c < 3 {
        println "Minimum is 3 digits, only has {c}.";
    } else if !(c % 2) {
        println "Number of digits must be odd, {c} is even.";
    } else if c == 3 {
        println "{s}";
    } else {
        let d = (c - 3) / 2;
        s[d + 3] = '\0';
        println "{s + d}";
   }
}

fn main() {
    let a = [123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0];
    for n in a { middle3(n); }
}
