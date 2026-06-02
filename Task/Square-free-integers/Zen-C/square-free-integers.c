fn is_square_free(n: u64) -> bool {
    let i: u64 = 2;
    let s: u64;
    while (s = i * i) <= n {
        if n % s == 0 { return false; }
        i += (i > 2) ? 2 : 1;
    }
    return true;
}

fn main() {
    let count = 0;
    println "The square-free integers between 1 and 145 inclusive are:";
    for let i: u64 = 1; i <= 145; ++i {
        if is_square_free(i) {
            print "{i:3lu} ";
            if !(++count % 20) { println ""; }
        }
    }

    count = 0;
    println "\n\nThe square-free integers between 1000000000000 and 1000000000145 inclusive are:";
    for let i: u64 = 1000000000000; i <= 1000000000145; ++i {
        if is_square_free(i) {
            print "{i:3lu} ";
            if !(++count % 5) { println ""; }
        }
    }

    count = 0;
    let pow: u64 = 100;
    println "\n\nCounts of square-free integers:";
    for let i: u64 = 1; i <= 1000000; ++i {
        if is_square_free(i) { count++; }
        if i == pow {
             println "  from 1 to {pow:-7lu} = {count}";
             pow *= 10;
        }
    }
}
