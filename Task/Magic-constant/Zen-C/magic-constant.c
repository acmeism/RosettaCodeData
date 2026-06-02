//> link: -lm

import "locale.h"
import "std/math.zc"
import "math.h" as c_math // for cbrt function

fn magic_constant(n: u64) -> u64 {
    return (n * n + 1) * n / 2;
}

fn main() {
    "First 20 magic constants:";
    for i in 3..=22 {
        let mc = magic_constant((u64)i);
        print "{mc:5ld}";
        if i == 12 || i == 22 { println ""; }
    }

    setlocale(LC_NUMERIC, "en_US.UTF-8");
    println "\n1,000th magic constant: {magic_constant(1002):'lu}";

    println "\nSmallest order magic square with a constant greater than:";
    for i in 1..=20 {
        let goal = Math::pow(10.0, i);
        let order = (u64)(Math::floor(c_math::cbrt(goal * 2.0))) + 1;
        println "10 ^ {i:2d} : {order:'9lu}";
    }
}
