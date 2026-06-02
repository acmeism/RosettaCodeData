import "locale.h"

fn main() {
    setlocale(LC_NUMERIC, "en_US.UTF-8");
    let starts: u64[5] = [100, 1_000_000, 10_000_000, 1_000_000_000, 7123];
    let totals: int[5] = [30, 15, 15, 10, 25];
    for i in 0..5 {
        let count = 0;
        let j = starts[i];
        let pow: u64 = 100;
        loop {
            if j < pow * 10 { break; }
            pow *= 10;
        }
        println "First {totals[i]} gapful numbers starting at {starts[i]:'lu}";
        while totals[i] > count {
            let fl = j / pow * 10 + (j % 10);
            if !(j % fl) {
                print "{j} ";
                count++;
            }
            if ++j >= 10 * pow { pow *= 10; }
        }
        println "\n";
    }
}
