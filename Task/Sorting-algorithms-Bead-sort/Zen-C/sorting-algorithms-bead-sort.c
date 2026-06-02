import "std/vec.zc"

fn bead_sort(a: uint*, len: const usize) -> Vec<uint> {
    let res = Vec<uint>::new();
    let max = a[0];
    for i in 1..len {
        if a[i] > max { max = a[i]; }
    }
    autofree let trans = (int*)calloc(max, sizeof(int));
    for i in 0..len {
        for n in 0..a[i] { trans[n]++; }
    }
    for i in 0..len {
        let count: uint = 0;
        for j in 0..max { if trans[j] > 0 { count++; } }
        res << count;
        for n in 0..max { trans[n]--; }
    }
    res.reverse(); // return in ascending order
    return res;
}

fn main() {
    let a1 = [4, 65, 2, 31, 0, 99, 2, 83, 782, 1];
    let a2 = [7, 5, 2, 6, 1, 4, 2, 6, 3];
    let aa: int*[2] = [a1, a2];
    let lens = [a1.len, a2.len];
    for i in 0..aa.len {
        print "Before: [";
        for j in 0..lens[i] { print "{aa[i][j]}, "; }
        println "\b\b]";
        let sorted = bead_sort(aa[i], lens[i]);
        print "After : [";
        for j in 0..lens[i] { print "{sorted[j]}, "; }
        println "\b\b]\n";
    }
}
