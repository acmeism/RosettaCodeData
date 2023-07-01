import strconv

fn main() {
    // cache factorials from 0 to 11
    mut fact := [12]u64{}
    fact[0] = 1
    for n := u64(1); n < 12; n++ {
        fact[n] = fact[n-1] * n
    }

    for b := 9; b <= 12; b++ {
        println("The factorions for base $b are:")
        for i := u64(1); i < 1500000; i++ {
            digits := strconv.format_uint(i, b)
            mut sum := u64(0)
            for digit in digits {
                if digit < `a` {
                    sum += fact[digit-`0`]
                } else {
                    sum += fact[digit+10-`a`]
                }
            }
            if sum == i {
                print("$i ")
            }
        }
        println("\n")
    }
}
