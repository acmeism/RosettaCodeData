import "std/vec.zc"

fn mult(n: u64, base: int) -> u64 {
    let m: u64 = 1;
    while m > 0 && n > 0 {
        let div = n / base;
        let rem = n % base;
        m *= rem;
        n = div;
    }
    return m;
}

// Only valid for n >= 0 && base >= 2.
fn mult_digital_root(n: u64, base: int) -> (int, int) {
    let mp = 0;
    while n >= base {
        n = mult(n, base);
        mp++;
    }
    return (mp, (int)n);
}

fn main() {
    def BASE = 10;
    def SIZE = 5;
    let tests: u64[7] = [
        123321, 7739, 893, 899998, 18446743999999999999, 3778888999, 277777788888899
    ];
    printf("%20s %3s %3s\n", "Number", "MDR", "MP");
    for n in tests {
        let (mp, dr) = mult_digital_root(n, BASE);
        printf("%20lu %3d %3d\n", n, dr, mp);
    }

    let list: Vec<u64>[BASE];
    for i in 0..BASE { list[i] = Vec<u64>::new(); }
    let cnt = SIZE * BASE;
    for let n: u64 = 0; cnt > 0; ++n {
        let (_, mdr) = mult_digital_root(n, BASE);
        if list[mdr].length() < SIZE {
            list[mdr] << n;
            cnt--;
        }
    }
    printf("\n%3s: %s\n", "MDR", "First");
    for i in 0..BASE {
        print "{i:3d}: [";
        for v in list[i] { print "{v}, "; }
        println "\b\b]";
    }
    for i in 0..BASE { list[i].free(); }
}
