import "std/vec.zc"

fn binary_search(a: Vec<int>*, value: int, low: int, high: int) -> int {
    let l = low;
    let h = high;
    while l <= h {
        let mid = l + (h - l) / 2;
        if a.get(mid) > value {
            h = mid - 1;
        } else if a.get(mid) < value {
            l = mid + 1;
        } else {
            return mid;
        }
    }
    return -1;
}

fn remove_element(a: Vec<int>*, v: int) {
    let ix = binary_search(a, v, 0, (int)a.length() - 1);
    if ix >= 0 { a.remove(ix) };
}

fn main() {
    def NMAX = 3200;
    let a = Vec<int>::with_capacity(NMAX);
    for i in 0..NMAX { a << (i + 1); }
    for piv in 2..a.length() {
        for let i = 0; i < piv - 1 && i < a.length() - 1; ++i {
            let su = a[i] + a[i + 1];
            remove_element(&a, su);
            for let j = i + 2; j < piv && j < a.length(); ++j {
                su += a[j];
                remove_element(&a, su);
                if su > NMAX { break; }
            }
        }
    }
    println "First hundred:";
    for i in 0..100 {
        print "{a[i]:3d}  ";
        if !((i + 1) % 10) { println ""; }
    }
    println "\nOne thousandth: {a[999]}";
}
