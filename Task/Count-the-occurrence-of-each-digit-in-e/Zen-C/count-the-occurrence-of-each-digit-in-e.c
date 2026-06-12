fn count_digits_in_e(n: int) {
    autofree let l: int* = malloc(n * sizeof(int));
    for i in 0..n { l[i] = 1; }
    let dc: [int; 10];
    dc[2] = 1;  // to count the non-fractional digit
    for col in 1..(2 * n) {
        let a = n + 1;
        let c = 0;
        for i in 0..n {
            c += l[i] * 10;
            l[i] = c % a;
            c /= a--;
        }
        dc[c]++;
    }
    for d in 0..=9 { println "{d}: {dc[d]}"; }
    let t = 0;
    for d in dc { t += d; }
    println "Total digits: {t}";
}

fn main() {
    count_digits_in_e(2000);
    println "";
    count_digits_in_e(3000);
}
