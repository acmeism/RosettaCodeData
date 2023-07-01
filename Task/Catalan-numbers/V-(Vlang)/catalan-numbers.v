import math.big

fn main() {
    mut b:= big.zero_int
    for n := i64(0); n < 15; n++ {
		b = big.integer_from_i64(n)
		b = (b*big.two_int).factorial()/(b.factorial()*(b*big.two_int-b).factorial())
        println(b/big.integer_from_i64(n+1))
    }
}
