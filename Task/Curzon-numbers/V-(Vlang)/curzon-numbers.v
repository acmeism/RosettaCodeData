import math.big

fn main() {
    zero := big.zero_int
    one := big.one_int
    for k := i64(2); k <= 10; k += 2 {
        bk := big.integer_from_i64(k)
        println("The first 50 Curzon numbers using a base of $k:")
        mut count := 0
        mut n := i64(1)
        mut pow := big.integer_from_i64(k)
        mut curzon50 := []i64{}
        for {
            z := pow + one
            d := k*n + 1
            bd := big.integer_from_i64(d)
            if z%bd == zero {
                if count < 50 {
                    curzon50 << n
                }
                count++
                if count == 50 {
                    for i in 0..curzon50.len {
                        print("${curzon50[i]:4} ")
                        if (i+1)%10 == 0 {
                            println('')
                        }
                    }
                    print("\nOne thousandth: ")
                }
                if count == 1000 {
                    println(n)
                    break
                }
            }
            n++
            pow *= bk
        }
        println('')
    }
}
