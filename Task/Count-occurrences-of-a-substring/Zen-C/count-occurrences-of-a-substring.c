fn str_occurs(s: string, t: string) -> int {
    let ptr = s;
    let count = 0;
    let l = strlen(t);
    if l == 0 { return -1; }
    loop {
        ptr = strstr(ptr, t);
        if ptr {
            count++;
            ptr += l;
        } else {
            break;
        }
    }
    return count;
}

fn str_quote(s: string, q: char*) {
    sprintf(q, "'%s'", s);
}

fn main() {
    let t1 = ["the three truths", "th"];
    let t2 = ["ababababab", "abab"];
    let t3 = ["abaabba*bbaba*bbab", "a*b"];
    let t4 = ["aaaaaaaaaaaaaa", "aa"];
    let t5 = ["aaaaaaaaaaaaaa", "b"];
    let ts: string*[5] = [t1, t2, t3, t4, t5];
    let q: char[10];
    for i in 0..5 {
        let t = ts[i];
        let count = str_occurs(t[0], t[1]);
        str_quote(t[1], q);
        println "{q:6s} occurs {count} times in '{t[0]}'";
    }
}
