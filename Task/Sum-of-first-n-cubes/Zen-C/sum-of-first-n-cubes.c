import "locale.h"

fn main() {
    setlocale(LC_NUMERIC, "en_US.UTF-8");
    println "Sums of the first 'n' cubes (0 <= n < 50):";
    let sum = 0;
    for i in 0..50 {
        sum += i * i * i;
        print "{sum:'9d} ";
        if i % 10 == 9 { println ""; }
    }
}
