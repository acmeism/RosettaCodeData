fn is_numeric(s: const string) -> bool {
    if !s || *s == '\0' { return false; }
    let p: char*;
    strtod(s, &p);
    return *p == '\0';
}

fn main() {
    println "Are these strings numeric?\n"
    let tests: const string[8] = [NULL, "1", " 3.14", "-100", "1e2", "NaN", "0xaf", "rose"];
    for t in tests {
        let isnum = is_numeric(t);
        let yn = isnum ? "yes" : "no";
        println "{t:-6s} -> {yn}";
    }
}
