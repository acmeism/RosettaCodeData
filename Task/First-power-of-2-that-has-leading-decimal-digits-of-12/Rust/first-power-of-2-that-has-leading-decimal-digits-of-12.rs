fn power_of_two(l: isize, n: isize) -> isize {
    let mut test: isize = 0;
    let log: f64 = 2.0_f64.ln() / 10.0_f64.ln();
    let mut factor: isize = 1;
    let mut looop = l;
    let mut nn = n;
    while looop > 10 {
        factor *= 10;
        looop /= 10;
    }

    while nn > 0 {
        test = test + 1;
        let val: isize = (factor as f64 * 10.0_f64.powf(test as f64 * log % 1.0)) as isize;

        if val == l {
            nn = nn - 1;
        }
    }

    test
}

fn run_test(l: isize, n: isize) {
    println!("p({}, {}) = {}", l, n, power_of_two(l, n));
}

fn main() {
    run_test(12, 1);
    run_test(12, 2);
    run_test(123, 45);
    run_test(123, 12345);
    run_test(123, 678910);
}
