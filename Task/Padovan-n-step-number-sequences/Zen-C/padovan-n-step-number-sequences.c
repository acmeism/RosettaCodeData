fn padovan_n(n: int, t: usize, p: int*) {
    if n < 2 || t < 3 {
        for i in 0..t { p[i] = 1; }
        return;
    }
    padovan_n(n - 1, t, p);
    for i in (n + 1)..t {
        p[i] = 0;
        for j in (i - 2)..=(i - n - 1) step -1 { p[i] += p[j]; }
    }
}

fn main() {
    let t: const usize = 15;
    let p: int[t];
    println "First {t} terms of the Padovan n-step number sequences:";
    for n in 2..=8 {
        for i in 0..t { p[i] = 0; }
        padovan_n(n, t, p);
        print "{n}: ";
        for i in 0..t { print "{p[i]:3d} "; }
        println "";
    }
}
