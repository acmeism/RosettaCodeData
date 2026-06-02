import "std/random.zc"

let rng: Random;

fn shuffle<T>(a: T*, len: usize) {
    for let i: usize = len - 1; i >= 1; --i {
        let j = rng.next_int_range(0, i);
        if j != i {
            let t = a[i];
            a[i] = a[j];
            a[j] = t;
        }
    }
}

fn is_sorted<T>(a: T*, len: usize) -> bool {
    for i in 1..len {
        if a[i] < a[i - 1] { return false; }
    }
    return true;
}

fn bogosort<T>(a: T*, len: usize) {
    while !is_sorted(a, len) {
        shuffle(a, len);
    }
}

fn main() {
    rng = Random::new();
    let a = [31, 41, 59, 26, 53, 58, 97, 93, 23, 84];
    print "Before: [";
    for i in 0..a.len { print "{a[i]}, "; }
    println "\b\b]";
    bogosort<int>(a, a.len);
    print "After : [";
    for i in 0..a.len { print "{a[i]}, "; }
    println "\b\b]";
}
