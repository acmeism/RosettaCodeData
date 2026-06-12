import "std/vec.zc"

fn is_prime(i: int) -> bool {
    return i == 2 || i == 3 || i == 5 || i == 7;
}

impl int {
    fn abs(self) -> int { return *self >= 0 ? *self : -(*self); }
}

fn main() {
    let count = 0;
    let d = Vec<int>::new();
    println "Strange numbers in the open interval (100, 500) are:\n";
    for i in 101..500 {
        d.clear();
        let j = i;
        while j > 0 {
            d << (j % 10);
            j /= 10;
        }
        if is_prime((d[0] - d[1]).abs()) && is_prime((d[1] - d[2]).abs()) {
            print "{i} ";
            if !(++count % 10) { println ""; }
        }
    }
    if count % 10 { println ""; }
    println "\n{count} strange numbers in all.";
}
