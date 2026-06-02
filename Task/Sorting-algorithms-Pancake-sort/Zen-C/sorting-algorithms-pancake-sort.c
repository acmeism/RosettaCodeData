fn flip(a: int*, r: usize) {
    for let l: usize = 0; l < r; ++l {
        let t = a[l];
        a[l] = a[r];
        a[r--] = t;
    }
}

fn pancake_sort(a: int*, len: const usize) {
    for let uns: usize = len - 1; uns > 0; --uns {
        let lx = 0;
        let lg = a[0];
        for i in 1..=uns {
            if a[i] > lg {
                lx = i;
                lg = a[i];
            }
        }
        flip(a, lx);
        flip(a, uns);
    }
}

fn main() {
    let list = [31, 41, 59, 26, 53, 58, 97, 93, 23, 84];
    print "unsorted: [";
    for e in list { print "{e}, "; }
    println "\b\b]";
    pancake_sort((int*)list, list.len);
    print "sorted  : [";
    for e in list { print "{e}, "; }
    println "\b\b]";
}
