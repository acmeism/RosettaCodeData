import "std/vec.zc"
import "std/math.zc"
import "locale.h"

fn main() {
    setlocale(LC_NUMERIC, "");
    let primes = Vec<u64>::new();
    primes << 3;
    primes << 5;
    let cut_off: const int = 200;
    let big_one: const int = 100_000;
    let cubans = Vec<u64>::new();
    let big_cuban: u64;
    let c = 0;
    let show_each = true;
    let u: u64 = 0;
    let v: u64 = 1;

    for i in 1..(1<<20) {
        let found = false;
        u += 6;
        v += u;
        let mx = (u64)Math::sqrt((f64)v);
        for item in primes {
            if item > mx { break; }
            if !(v % item) {
                found = true;
                break;
            }
        }
        if !found {
            c++;
            if show_each {
                let z = primes.last();
                while z <= v - 2 {
                    z += 2;
                    let fnd = false;
                    for item in primes {
                        if item > mx { break; }
                        if !(z % item) {
                            fnd = true;
                            break;
                        }
                    }
                    if !fnd {
                        primes << z;
                    }
                }
                primes << v;
                cubans << v;
                if c == cut_off { show_each = false; }
            }
            if c == big_one {
                big_cuban = v;
                break;
            }
        }
    }

    println "The first 200 cuban primes are:-";
    for i in 0..20 {
        let j = i * 10;
        for k in j..(j + 10) { print "{cubans[k]:'10lu}"; } // 10 per line say
        println "";
    }

    println "\nThe 100,000th cuban prime is {big_cuban:'lu}";
}
