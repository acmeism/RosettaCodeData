fn shell_sort(a: int*, n: usize) {
    let gaps = [701, 301, 132, 57, 23, 10, 4, 1];
    for gap in gaps {
        if gap < n {
            for i in gap..n {
                let t = a[i];
                let j = i;
                while j >= gap && a[j - gap] > t {
                    a[j] = a[j - gap];
                    j -= gap;
                }
                a[j] = t;
            }
        }
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
        shell_sort(aa[i], lens[i]);
        print "After : [";
        for j in 0..lens[i] { print "{aa[i][j]}, "; }
        println "\b\b]\n";
    }
}
