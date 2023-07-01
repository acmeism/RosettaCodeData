fn cocktail_sort<T: PartialOrd>(a: &mut [T]) {
    let len = a.len();
    loop {
        let mut swapped = false;
        let mut i = 0;
        while i + 1 < len {
            if a[i] > a[i + 1] {
                a.swap(i, i + 1);
                swapped = true;
            }
            i += 1;
        }
        if swapped {
            swapped = false;
            i = len - 1;
            while i > 0 {
                if a[i - 1] > a[i] {
                    a.swap(i - 1, i);
                    swapped = true;
                }
                i -= 1;
            }
        }
        if !swapped {
            break;
        }
    }
}

fn main() {
    let mut v = vec![10, 8, 4, 3, 1, 9, 0, 2, 7, 5, 6];
    println!("before: {:?}", v);
    cocktail_sort(&mut v);
    println!("after:  {:?}", v);
}
