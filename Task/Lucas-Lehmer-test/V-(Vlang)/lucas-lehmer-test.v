import math.big
const (
    primes = [u32(3), 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47,
    53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127]

    mersennes = [u32(521), 607, 1279, 2203, 2281, 3217, 4253, 4423, 9689,
    9941, 11213, 19937, 21701, 23209, 44497, 86243, 110503, 132049, 216091,
    756839, 859433, 1257787, 1398269, 2976221, 3021377, 6972593, 13466917,
    20996011, 24036583]
)

fn main() {
    ll_test(primes)
    println('')
    ll_test(mersennes)
}

fn ll_test(ps []u32) {
    mut s, mut m := big.zero_int, big.zero_int
    one := big.one_int
    two := big.two_int
    for p in ps {
        m = one.lshift(p) - one
        s= big.integer_from_int(4)
        for i := u32(2); i < p; i++ {
            s = (s*s - two)%m
        }
        if s.bit_len() == 0 {
            print("M$p ")
        }
    }
}
