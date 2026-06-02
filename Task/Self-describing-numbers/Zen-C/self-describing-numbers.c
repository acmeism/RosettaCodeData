import "std/string.zc"

fn is_self_describing(n: u64) -> bool {
    let ns = "{n}";
    let nc = strlen(ns);
    autofree let count = (int*)calloc(nc, sizeof(int));
    let sum = 0;
    while n > 0 {
        let d = n % 10;
        if d >= nc { return false; }  // can't have a digit >= number of digits
        sum += d;

        if sum > nc { return false; }
        count[d] += 1;
        n /= 10;
    }

    // To be self-describing sum of digits must equal number of digits.
    if sum != nc { return false; }
    let s = String::from("");
    for i in 0..nc { s.append_c("{count[i]}"); }
    return strcmp(ns, s.c_str()) == 0; // there must always be at least one zero
}

fn main() {
    println "The self-describing numbers are:";
    let i:  u64 = 10;  // self-describing number must end in 0
    let pw: u64 = 10;  // power of 10
    let fd: u64 = 1;   // first digit
    let sd: i64 = 1;   // second digit
    let dg: u64 = 2;   // number of digits
    let mx: u64 = 11;  // maximum for current batch

    let lim: u64 = 9_100_000_001; // sum of digits can't be more than 10
    while i < lim {
        if is_self_describing(i) { println "{i:lu}"; }
        i += 10;
        if i > mx {
            fd++;
            sd--;
            if sd >= 0 {
                i = fd * pw;
            } else {
                pw *= 10;
                dg += 1;
                i = pw;
                fd = 1;
                sd = dg - 1;
            }
            mx = i + sd * pw / 10;
        }
    }
}
