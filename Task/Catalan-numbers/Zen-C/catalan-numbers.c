import "locale.h"

fn factorial(n: u64) -> u64 {
    let prod: u64 = 1;
    for i in 2..=n { prod *= i; }
    return prod;
}

fn catalan(n: u64) -> u64 {
    let prod: u64 = 1;
    let i = n + 2;
    while i <= n * 2 { prod *= i++; }
    return prod / factorial(n);
}

fn catalan_rec(n: u64) -> u64 {
    return (n != 0) ? 2 * (2 * n - 1) * catalan_rec(n - 1) / (n + 1) : 1;
}

fn main() {
    setlocale(LC_NUMERIC, "en_US.UTF-8");
    println " n  Catalan number";
    println "------------------";
    for i in 0..=15 { printf("%2d  %'9lu\n", i, catalan((u64)i)); }
    println "\nand again using a recursive function:\n";
    for i in 0..=15 { printf("%2d  %'9lu\n", i, catalan_rec((u64)i)); }
}
