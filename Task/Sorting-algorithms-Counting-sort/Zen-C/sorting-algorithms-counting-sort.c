fn counting_sort(a: int*, len: const usize, min: int, max: int) {
    autofree let count = (int*)calloc(max - min + 1, sizeof(int));
    for i in 0..len { count[a[i] - min]++; }
    let z = 0;
    for i in min..=max {
        while count[i - min] > 0 {
            a[z++] = i;
            count[i - min]--;
        }
    }
}

fn minimum(a: int*, len: const usize) -> int {
    let res = a[0];
    for i in 1..len {
        if a[i] < res { res = a[i]; }
    }
    return res;
}

fn maximum(a: int*, len: const usize) -> int {
    let res = a[0];
    for i in 1..len {
        if a[i] > res { res = a[i]; }
    }
    return res;
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
        let min = minimum(aa[i], lens[i]);
        let max = maximum(aa[i], lens[i]);
        counting_sort(aa[i], lens[i], min, max);
        print "After : [";
        for j in 0..lens[i] { print "{aa[i][j]}, "; }
        println "\b\b]\n";
    }
}
