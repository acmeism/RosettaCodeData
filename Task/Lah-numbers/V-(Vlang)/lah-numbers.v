import math.big

fn main() {
    limit := 100
    last := 12
    unsigned := true
    mut l := [][]big.Integer{len: limit+1}
    for n := 0; n <= limit; n++ {
        l[n] = []big.Integer{len: limit+1}
        for k := 0; k <= limit; k++ {
            l[n][k] = big.zero_int
        }
        l[n][n]= big.integer_from_int(1)
        if n != 1 {
            l[n][1]= big.integer_from_int(n).factorial()
        }
    }
    mut t := big.zero_int
    for n := 1; n <= limit; n++ {
        for k := 1; k <= n; k++ {
            t = l[n][1] * l[n-1][1]
            t /= l[k][1]
            t /= l[k-1][1]
            t /= l[n-k][1]
            l[n][k] = t
            if !unsigned && (n%2 == 1) {
                l[n][k] = l[n][k].neg()
            }
        }
    }
    println("Unsigned Lah numbers: l(n, k):")
    print("n/k")
    for i := 0; i <= last; i++ {
        print("${i:10} ")
    }
    print("\n--")
    for i := 0; i <= last; i++ {
        print("-----------")
    }
    println('')
    for n := 0; n <= last; n++ {
        print("${n:2} ")
        for k := 0; k <= n; k++ {
            print("${l[n][k]:10} ")
        }
        println('')
    }
    println("\nMaximum value from the l(100, *) row:")
    mut max := l[limit][0]
    for k := 1; k <= limit; k++ {
        if l[limit][k] > max {
            max = l[limit][k]
        }
    }
    println(max)
    println("which has ${max.str().len} digits.")
}
