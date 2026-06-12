fn circle_sort(a: int*, lo: int, hi: int, swaps: int) -> int {
    if lo == hi { return swaps; }
    let high = hi;
    let low  = lo;
    let mid  = (hi - lo) / 2;
    while lo < hi {
        if a[lo] > a[hi] {
            let t = a[lo];
            a[lo] = a[hi];
            a[hi] = t;
            swaps++;
        }
        lo++;
        hi--;
    }
    if lo == hi {
        if a[lo] > a[hi + 1] {
            let t = a[lo];
            a[lo] = a[hi + 1];
            a[hi + 1] = t;
            swaps++;
        }
    }
    circle_sort(a, low, low + mid, swaps);
    circle_sort(a, low + mid + 1, high, swaps);
    return swaps;
}

fn main() {
    let a1 = [6, 7, 8, 9, 2, 5, 3, 4, 1];
    let a2 = [2, 14, 4, 6, 8, 1, 3, 5, 7, 11, 0, 13, 12, -1];
    let aa: int*[2] = [a1, a2];
    let lens = [a1.len, a2.len];
    for i in 0..aa.len {
        print "Before: [";
        for j in 0..lens[i] { print "{aa[i][j]}, "; }
        println "\b\b]";
        while circle_sort(aa[i], 0, (int)lens[i] - 1, 0) {};
        print "After : [";
        for j in 0..lens[i] { print "{aa[i][j]}, "; }
        println "\b\b]\n";
    }
}
