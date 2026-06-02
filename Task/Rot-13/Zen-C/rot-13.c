fn rot13(s: const char*, r: char*) {
    let len: usize = strlen(s);
    for i in 0..len {
        let c = s[i];
        if (c >= 'A' && c <= 'M') || (c >= 'a' && c <= 'm') {
            r[i] = c + 13;
        } else if (c >= 'N' && c <= 'Z') || (c >= 'n' && c <= 'z') {
            r[i] = c - 13;
        } else {
            r[i] = c;
        }
    }
    r[len] = '\0';
}

fn main() {
    let s = "nowhere ABJURER";
    autofree let r: char* = malloc(strlen(s) + 1);
    rot13(s, r);
    println "{r}";
}
