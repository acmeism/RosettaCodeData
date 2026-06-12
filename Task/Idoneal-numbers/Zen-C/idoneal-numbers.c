fn is_idoneal(n: int) -> bool {
    for a in 1..n {
        for b in (a + 1)..n {
            if a * b + a + b > n { break; }
            for c in (b + 1)..n {
                let sum = a * b + b * c + a * c;
                if sum == n { return false; }
                if sum > n  { break; }
            }
        }
    }
    return true;
}

fn main() {
    let count = 0;
    for let n = 1; count < 65; ++n {
        if is_idoneal(n) {
            print "{n:4d} ";
            if !(++count % 10) { println ""; }
        }
    }
    println "\n\nFound all {count} known Idoneal numbers.";
}
