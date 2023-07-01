fn mertens(t int) ([]int, int, int) {
    mut to:=t
    if to < 1 {
        to = 1
    }
    mut merts := []int{len:to+1}
    mut primes := [2]
    mut sum := 0
    mut zeros := 0
    mut crosses := 0
    for i := 1; i <= to; i++ {
        mut j := i
        mut cp := 0      // counts prime factors
        mut spf := false // true if there is a square prime factor
        for p in primes {
            if p > j {
                break
            }
            if j%p == 0 {
                j /= p
                cp++
            }
            if j%p == 0 {
                spf = true
                break
            }
        }
        if cp == 0 && i > 2 {
            cp = 1
            primes << i
        }
        if !spf {
            if cp%2 == 0 {
                sum++
            } else {
                sum--
            }
        }
        merts[i] = sum
        if sum == 0 {
            zeros++
            if i > 1 && merts[i-1] != 0 {
                crosses++
            }
        }
    }
    return merts, zeros, crosses
}

fn main() {
    merts, zeros, crosses := mertens(1000)
    println("Mertens sequence - First 199 terms:")
    for i := 0; i < 200; i++ {
        if i == 0 {
            print("    ")
            continue
        }
        if i%20 == 0 {
            println('')
        }
        print("  ${merts[i]:2}")
    }
    println("\n\nEquals zero $zeros times between 1 and 1000")
    println("\nCrosses zero $crosses times between 1 and 1000")
}
