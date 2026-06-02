fn selection_sort(a: int*, len: const usize) {
    let last = len - 1;
    for i in 0..last {
        let a_min = a[i];
        let i_min = i;
        for j in (i + 1)..=last {
            if a[j] < a_min {
                a_min = a[j];
                i_min = j;
            }
        }
        let t = a[i];
        a[i] = a_min;
        a[i_min] = t;
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
        selection_sort(aa[i], lens[i]);
        print "After : [";
        for j in 0..lens[i] { print "{aa[i][j]}, "; }
        println "\b\b]\n";
    }
}
