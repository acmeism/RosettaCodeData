fn main() {
    let s: char[9];
    for n in 0..8 {
        if n > 0 { s[n - 1] = '1'; }
        s[n] = '3';
        s[n + 1] = '\0';
        let i: u64 = atoll(s);
        println "{s:9s} {i * i:15lu}";
    }
}
