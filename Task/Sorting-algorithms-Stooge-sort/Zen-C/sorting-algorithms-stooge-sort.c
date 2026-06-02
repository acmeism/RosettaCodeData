fn stooge_sort(a: int*, i: int, j: int) {
    if a[j] < a[i] {
        let t = a[i];
        a[i] = a[j];
        a[j] = t;
    }
    if j - i > 1 {
        let t = (j - i + 1) / 3;
        stooge_sort(a, i, j - t);
        stooge_sort(a, i + t, j);
        stooge_sort(a, i, j - t);
    }
}

fn main() {
    let a1 = [4, 65, 2, -31, 0, 99, 2, 83, 782, 1];
    let a2 = [7, 5, 2, 6, 1, 4, 2, 6, 3];
    let aa: int*[2] = [a1, a2];
    let lens = [a1.len, a2.len];
    for i in 0..aa.len {
        print "Before: [";
        for j in 0..lens[i] { print "{aa[i][j]}, "; }
        println "\b\b]";
        stooge_sort(aa[i], 0, lens[i] - 1);
        print "After : [";
        for j in 0..lens[i] { print "{aa[i][j]}, "; }
        println "\b\b]\n";
    }
}
