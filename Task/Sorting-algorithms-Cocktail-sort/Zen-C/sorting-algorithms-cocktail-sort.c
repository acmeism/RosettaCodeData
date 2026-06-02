fn cocktail_sort(a: int*, len: const usize) {
    let last = (int)len - 1;
    loop {
        let swapped = false;
        for i in 0..last {
            if a[i] > a[i + 1] {
                let t = a[i];
                a[i] = a[i + 1];
                a[i + 1] = t;
                swapped = true;
            }
        }
        if !swapped { return; }
        swapped = false;
        if last >= 1 {
            for i in (last - 1)..=0 step - 1 {
                if a[i] > a[i + 1] {
                    let t = a[i];
                    a[i] = a[i + 1];
                    a[i + 1] = t;
                    swapped = true;
                }
            }
        }
        if !swapped { return; }
    }
}

fn main() {
    let a = [170, 45, 75, -90, -802, 24, 2, 66];
    print "Before: [";
    for i in 0..a.len { print "{a[i]}, "; }
    println "\b\b]";
    cocktail_sort((int*)a, a.len);
    print "After : [";
    for i in 0..a.len { print "{a[i]}, "; }
    println "\b\b] ";
}
