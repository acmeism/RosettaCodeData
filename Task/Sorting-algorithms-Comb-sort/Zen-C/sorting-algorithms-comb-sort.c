fn comb_sort(a: int*, len: const usize) {
    let gap = (f64)len;
    loop {
        gap /= 1.25;
        if gap < 1.0 { gap = 1.0; }
        let swaps = false;
        let ugap = (usize)gap;
        let i: usize = 0
        do {
            if a[i] > a[i + ugap] {
                let t = a[i];
                a[i] = a[i + ugap];
                a[i + ugap] = t;
                swaps = true;
            }
            i++;
        } while i + ugap < len;
        if ugap == 1 && !swaps { return; }
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
        comb_sort(aa[i], lens[i]);
        print "After : [";
        for j in 0..lens[i] { print "{aa[i][j]}, "; }
        println "\b\b]\n";
    }
}
