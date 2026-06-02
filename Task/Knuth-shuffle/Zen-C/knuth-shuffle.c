import "std/random.zc"

fn knuth_shuffle<T>(a: T*, len: usize) {
    let rng = Random::new();
    for let i: usize = len - 1; i >= 1; --i {
        let j = rng.next_int_range(0, i);
        if j != i {
            let t = a[i];
            a[i] = a[j];
            a[j] = t;
        }
    }
}

fn main() {
    let a1 = [10];
    let a2 = [10, 20];
    let a3 = [10, 20, 30];
    let aa: int*[3] = [a1, a2, a3];
    for i in 0..3 {
        let a = aa[i];
        for j in 0..(i + 1) { print "{a[j]}, "; }
        print "\b\b -> ";
        knuth_shuffle<int>(a, (usize)(i + 1));
        for j in 0..(i + 1) { print "{a[j]}, "; }
        println "\b\b ";
    }
}
