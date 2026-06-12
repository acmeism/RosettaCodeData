fn gospers_hack(x: int) -> int {
    let c = x & -x;
    let r = x + c;
    return (((r ^ x) >> 2) / c) | r;
}

fn main() {
    let a = [1, 3, 7, 15];
    for start in a {
        print "{start:2d}:";
        let x = start;
        for i in 0..10 {
            x = gospers_hack(x);
            print " {x:4d}";
        }
        println "";
    }
}
