import "std/vec.zc"
import "std/math.zc"

// Recursively permutates the list of squares to seek a matching sum.
fn soms(n: int, f: Vec<int>*) -> bool {
    if n <= 0 { return false; }
    if f.contains(n) { return true; }
    let sum = 0;
    for v in *f { sum += v; }
    if n > sum { return false; }
    if n == sum { return true; }
    let rf = f.clone();
    rf.reverse();
    rf.remove(0);
    return soms(n - f.last(), &rf) || soms(n, &rf);
}

fn main() {
    let s = Vec<int>::new();
    let a = Vec<int>::new();
    let sf = "\nStopped checking after finding %d sequential non-gaps after the final gap of %d.\n";
    let i = 1;
    let g = 1;
    while g >= (i >> 1) {
        let r = (int)Math::sqrt((f64)i);
        if r * r == i { s << i; }
        if !soms(i, &s) {
            g = i;
            a << g;
        }
        i++;
    }
    println "Numbers which are not the sum of distinct squares:";
    for v in a { print "{v}, "; }
    println "\b\b ";
    println "\nFound {a.length()} such numbers.";
    printf(sf, i - g, g);
}
