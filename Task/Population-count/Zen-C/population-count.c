import "std/vec.zc"

fn pop_count<T>(n: T) -> int {
    let count = 0;
    while n {
        n = n & (n - 1);
        count++;
    }
    return count;
}

fn main() {
    println "The population count of the first 30 powers of 3 is:";
    let p3: u64 = 1;
    for i in 0..30 {
        print "{pop_count<u64>(p3)} ";
        p3 *= 3;
    }
    let odious = Vec<int>::new();
    println "\n\nThe first 30 evil numbers are:";
    let count = 0;
    let n = 0
    for ; count < 30; ++n {
        let pc = pop_count<int>(n);
        if !(pc % 2) {
            print "{n} ";
            count++;
        } else {
            odious << n;
        }
    }
    odious << n;
    println "\n\nThe first 30 odious numbers are:";
    for o in odious { print "{o} "; }
    println "";
}
