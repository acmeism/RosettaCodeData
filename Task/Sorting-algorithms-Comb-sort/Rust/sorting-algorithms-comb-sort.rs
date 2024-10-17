fn comb_sort<T: PartialOrd>(a: &mut [T]) {
    let len = a.len();
    let mut gap = len;
    let mut swapped = true;
    while gap > 1 || swapped {
        gap = (4 * gap) / 5;
        if gap < 1 {
            gap = 1;
        }
        let mut i = 0;
        swapped = false;
        while i + gap < len {
            if a[i] > a[i + gap] {
                a.swap(i, i + gap);
                swapped = true;
            }
            i += 1;
        }
    }
}

fn main() {
    let mut v = vec![10, 8, 4, 3, 1, 9, 0, 2, 7, 5, 6];
    println!("before: {:?}", v);
    comb_sort(&mut v);
    println!("after:  {:?}", v);
}
