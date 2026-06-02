fn ends_with(s1: char*, s2: char*) -> bool {
    let l1 = strlen(s1);
    let l2 = strlen(s2);
    if l2 > l1 { return false; }
    for i in 0..l2 {
        if s1[l1 - i - 1] != s2[l2 - i - 1] { return false; }
    }
    return true;
}

fn duration(s: int) {
    if s < 1 {
        println "0 sec";
        return;
    }
    let dur: char[30] = [0];
    let divs: int[5] = [7, 24, 60, 60, 1];
    let units: string[5] = ["wk", "d", "hr", "min", "sec"];
    let t = 1;
    for d in divs { t *= d; }
    for i in 0..5 {
        let u = s / t;
        if u > 0 {
            strcat(dur, "{u} {units[i]}, ");
            s %= t;
        }
        t /= divs[i];
    }
    if ends_with(dur, ", ") { dur[strlen(dur) - 2] = '\0'; }
    println "{dur}";
}

fn main() {
    let tests: int[3] = [7_259, 86_400, 6_000_000];
    for t in tests { duration(t); }
}
