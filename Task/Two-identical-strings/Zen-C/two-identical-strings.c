fn batoi(s: string) -> int {
    let res = 0;
    for i in 0..strlen(s) {
        let d = s[i] - 48;
        res = res * 2 + d;
    }
    return res;
}

fn main() {
    let i = 1;
    let s: [char; 20];
    loop {
        let b2 = "{i:b}";
        strcat(s, b2);
        strcat(s, b2);
        let d = batoi(s);
        if d >= 1000 { break; }
        println "{d:3d} : {s}";
        i++;
        s[0] = '\0';
    }
    println "\nFound {i - 1} numbers.";
}
