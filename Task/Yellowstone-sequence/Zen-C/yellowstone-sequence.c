import "std/set.zc"

fn gcd(x: int, y: int) -> int {
    while y {
        let t = y;
        y = x % y;
        x = t;
    }
    return x >= 0 ? x :-x;
}

fn yellowstone(n: int, a: int*) {
    let s = Set<int>::new();
    for i in 1..4 {
        a[i] = i;
        s.add(i);
    }
    let min = 4;
    for c in 4..=n {
        for let i = min; ; ++i {
            if !s.contains(i) && gcd(a[c - 1], i) == 1 && gcd(a[c - 2], i) > 1 {
                a[c] = i;
                s.add(i);
                if i == min { min++; }
                break;
            }
        }
    }
}

fn main() {
    let x: int[30];
    for i in 0..30 { x[i] = i + 1; }
    let a: [int; 31];
    yellowstone(30, (int*)a);
    println "The first 30 Yellowstone numbers are:";
    for i in 1..=30 {
        print "{a[i]:2d}  ";
        if !(i % 10) { println ""; }
    }
}
