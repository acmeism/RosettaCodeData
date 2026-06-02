import "std/vec.zc"

fn divisors(n: int) -> Vec<int> {
    let divs = Vec<int>::new();
    if n < 1 { return divs; }
    let divs2 = Vec<int>::new();
    let i = 1;
    let k = (n % 2 == 0) ? 1 : 2;
    while i * i <= n {
        if n % i == 0 {
            divs << i;
            let j = n / i;
            if j != i { divs2 << j; }
        }
        i += k;
    }
    if divs2.length() {
        divs2.reverse();
        for l in 0..divs2.length() { divs << divs2[l]; }
    }
    return divs;
}

fn main() {
    let a = [11, 21, 32, 45, 67, 96, 159, 723, 1024, 5673, 12345, 32767, 123459, 999997];
    println "The factors of the following numbers are:";
    for e in a {
        print "{e:6d} => [";
        let divs = divisors(e);
        for i in 0..divs.length() { print "{divs[i]}, "; }
        println "\b\b]";
    }
}
