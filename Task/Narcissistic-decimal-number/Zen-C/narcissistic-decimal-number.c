import "std/vec.zc"

fn narc(n: int) -> Vec<int> {
    let power: [int; 10];
    for i in 0..10 { power[i] = i; }
    let limit = 10;
    let res = Vec<int>::new();
    for let x = 0; res.length() < n; ++x {
        if x >= limit {
            for i in 0..10 { power[i] *= i; }
            limit *= 10;
        }
        let sum = 0;
        let xx = x;
        while xx > 0 {
            sum += power[xx % 10];
            xx /= 10;
        }
        if sum == x { res << x; }
    }
    return res;
}

fn main() {
    println "The first 25 narcissistic decimal numbers are:"
    let res = narc(25);
    for n in res {
        print "{n} ";
    }
    println "";
}
