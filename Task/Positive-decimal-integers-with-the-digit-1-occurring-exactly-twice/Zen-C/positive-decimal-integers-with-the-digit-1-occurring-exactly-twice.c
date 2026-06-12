fn two_ones(n: int) -> bool {
    let s = "{n}";
    let ones = 0;
    for i in 0..strlen(s) {
        if s[i] == '1' { ones++; }
    }
    return ones == 2;
}

fn main() {
    println "Decimal numbers under 1,000 whose digits include two 1's:";
    let count = 0;
    for i in 1..1000 {
        if two_ones(i) {
            print "{i:3d}  ";
            if !(++count % 9) { println ""; }
        }
    }
    println "\nFound {count} such numbers.";
}
