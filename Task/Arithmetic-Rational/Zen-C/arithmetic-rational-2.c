import "std/vec.zc"
import "rat.zc"

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
    println "The following numbers (less than 2^19) are perfect:";
    let one: const Rat = Rat::new(1);
    for i in 2..(1 << 19) {
        let sum = Rat::new(1, i);
        let pd = divisors(i);
        for j in 1..(pd.length() - 1) { sum += Rat::new(1, pd[j]); }
        if sum == one { println "  {i}"; }
    }
}
