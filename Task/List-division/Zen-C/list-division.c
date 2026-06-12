import "std/vec.zc"

def BS2 = "\x08\x08";

fn list_divide(a: int*, c: const usize, n: const int) {
    assert(n > 0, "'n' must be a positive integer.");
    let q: int = c / n;
    let r: int = c % n;
    let p = Vec<int>::new();
    if r > 0 {
        for i in 1..=r { p << (q + 1); }
    }
    // Only include non-empty parts.
    if q > 0 {
        for i in 1..=(n - r) { p << q; }
    }
    let pc = p.length();
    let res = Vec<Vec<int>>::new();
    let start = 0;
    for i in 0..pc {
        let chunk = Vec<int>::new()
        let end = start + p[i];
        for j in start..end { chunk << a[j]; }
        res << chunk;
        start = end;
    }

    print "[";
    for i in 0..res.length() {
        print "[";
        for j in res[i] { print "{j}, "; }
        print "{BS2}], ";
    }
    println "{BS2}]";
}

fn main() {
    let t1: int[9]  = [94, 94, 13, 77, 35, 10, 51, 27, 60];
    let t2: int[5]  = [19, 46, 43, 17, 94];
    let t3: int[8]  = [93, 88, 40, 88, 30, 68, 84, 25];
    let t4: int[6]  = [88, 94, 10, 27, 54, 14];
    let t5: int[9]  = [31, 19, 63, 57, 57, 74, 50, 14, 38];
    let t6: int[10] = [72, 57, 89, 55, 36, 84, 10, 95, 99, 35];
    let t7: int[3]  = [23, 49, 57];
    let t8: int[1]  = [1];

    let tests: int*[8] = [t1, t2, t3, t4, t5, t6, t7, t8];
    let cs: usize[8] = [9, 5, 8, 6, 9, 10, 3, 1];
    let ns:   int[8] = [6, 1, 3, 3, 4, 7, 10, 2];

    for i in 0..8 { list_divide(tests[i], cs[i], ns[i]); }
}
