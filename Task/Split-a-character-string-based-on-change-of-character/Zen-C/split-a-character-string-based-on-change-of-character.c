fn split(s: string) {
    let len = strlen(s);
    if len == 0 { return; }
    let last = s[0];
    for i in 0..len {
        let curr = s[i];
        if curr == last {
            print "{curr:c}";
        } else {
            print ", {curr:c}";
            last = curr;
        }
    }
    println "";
}

fn main() {
    let s = "gHHH5YY++///\\";
    split(s);
}
