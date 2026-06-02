fn sift_down(a: int*, start: int, end: int) {
    let root = start;
    while root * 2 + 1 <= end {
        let child = root * 2 + 1;
        if child + 1 <= end && a[child] < a[child + 1]  { child++; }
        if a[root] < a[child] {
            let t = a[root];
            a[root] = a[child];
            a[child] = t;
            root = child;
        } else {
            return;
        }
    }
}

fn heapify(a: int*, count: const int) {
    let start = (count - 2) / 2;
    while start >= 0 {
        sift_down(a, start, count - 1);
        start--;
    }
}

fn heap_sort(a: int*, count: const int) {
    heapify(a, count);
    let end = count - 1;
    while end > 0 {
        let t = a[end];
        a[end] = a[0];
        a[0] = t;
        sift_down(a, 0, --end);
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
        heap_sort(aa[i], lens[i]);
        print "After : [";
        for j in 0..lens[i] { print "{aa[i][j]}, "; }
        println "\b\b]\n";
    }
}
