import "std/random.zc"

let rng: Random;

fn sattolo<T>(a: T*, len: const usize) {
    for let i = len - 1; i >= 1; --i {
        let j = rng.next_int_range(0, i - 1);
        let t = a[i];
        a[i] = a[j];
        a[j] = t;
    }
}

fn main() {
    rng = Random::new();

    let a1 = [10];
    let a2 = [10, 20];
    let a3 = [10, 20, 30];
    let a4 = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22];
    let aa: int*[4]= [a1, a2, a3, a4];
    let alen: usize[4] = [1, 2, 3, 12];
    for i in 0..4 {
        let a = aa[i];
        print "Original: ["
        for j in 0..alen[i] { print "{a[j]}, "; }
        println "\b\b]";
        sattolo(a, alen[i]);
        print "Sattolo : [";
        for j in 0..alen[i] { print "{a[j]}, "; }
        println "\b\b]\n";
    }

    let b1 = ["a", "b", "c", "d", "e"];
    let b2 = ["fgh", "ijk", "lmn", "opq", "rst", "uvw", "xyz"];
    let bb: string*[2] = [b1, b2];
    let blen: usize[2] = [5, 7];
    for i in 0..2 {
        let b = bb[i];
        print "Original: ["
        for j in 0..blen[i] { print "{b[j]}, "; }
        println "\b\b]";
        sattolo(b, blen[i]);
        print "Sattolo : [";
        for j in 0..blen[i] { print "{b[j]}, "; }
        println "\b\b]\n";
    }
}
