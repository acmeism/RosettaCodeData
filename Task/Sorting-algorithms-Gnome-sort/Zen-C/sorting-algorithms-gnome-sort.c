fn gnome_sort(a: int*, size: const usize, asc: bool) {
    let i = 1;
    let j = 2;
    while i < size {
        if (asc && a[i - 1] <= a[i]) || (!asc && a[i - 1] >= a[i]) {
            i = j;
            j++;
        } else {
            let t = a[i - 1];
            a[i - 1] = a[i];
            a[i] = t;
            if !(--i) {
                i = j;
                j++;
            }
        }
    }
}

fn main() {
    let a1 = [4, 65, 2, -31, 0, 99, 2, 83, 782, 1];
    let a2 = [7, 5, 2, 6, 1, 4, 2, 6, 3];
    let aa: int*[2] = [a1, a2];
    let lens = [a1.len, a2.len];
    let ba: bool[2] = [true, false];
    for asc in ba {
        let dir = asc ? "ascending" : "descending";
        println "Sorting in {dir} order:\n";
        for i in 0..aa.len {
            print "  Before: [";
            for j in 0..lens[i] { print "{aa[i][j]}, "; }
            println "\b\b]";
            gnome_sort(aa[i], lens[i], asc);
            print "  After : [";
            for j in 0..lens[i] { print "{aa[i][j]}, "; }
            println "\b\b]\n";
        }
    }
}
