fn _circle_sort<T: PartialOrd>(a: &mut [T], low: usize, high: usize, swaps: usize) -> usize {
    if low == high {
        return swaps;
    }
    let mut lo = low;
    let mut hi = high;
    let mid = (hi - lo) / 2;
    let mut s = swaps;
    while lo < hi {
        if a[lo] > a[hi] {
            a.swap(lo, hi);
            s += 1;
        }
        lo += 1;
        hi -= 1;
    }
    if lo == hi {
        if a[lo] > a[hi + 1] {
            a.swap(lo, hi + 1);
            s += 1;
        }
    }
    s = _circle_sort(a, low, low + mid, s);
    s = _circle_sort(a, low + mid + 1, high, s);
    return s;
}

fn circle_sort<T: PartialOrd>(a: &mut [T]) {
    let len = a.len();
    loop {
        if _circle_sort(a, 0, len - 1, 0) == 0 {
            break;
        }
    }
}

fn main() {
    let mut v = vec![10, 8, 4, 3, 1, 9, 0, 2, 7, 5, 6];
    println!("before: {:?}", v);
    circle_sort(&mut v);
    println!("after:  {:?}", v);
}
