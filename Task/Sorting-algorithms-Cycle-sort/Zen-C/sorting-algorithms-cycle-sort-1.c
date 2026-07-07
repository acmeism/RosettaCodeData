fn cycle_sort(a: int*, len: const usize) -> int {
    let writes = 0;
    for cs in 0..(len - 1) {
        let item = a[cs];
        let pos = cs;
        for i in (cs + 1)..len {
            if a[i] < item { pos++; }
        }
        if pos != cs {
            while item == a[pos] { pos++; }
            let t = a[pos];
            a[pos] = item;
            item = t;
            while pos != cs {
                pos = cs;
                for i in (cs + 1)..len {
                    if a[i] < item { pos++; }
                }
                while item == a[pos] { pos++; }
                let u = a[pos];
                a[pos] = item;
                item = u;
                writes++;
            }
        }
    }
    return writes;
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
        let w = cycle_sort(aa[i], lens[i]);
        print "After : [";
        for j in 0..lens[i] { print "{aa[i][j]}, "; }
        println "\b\b] ";
        println "Writes : {w}\n";
    }
}
