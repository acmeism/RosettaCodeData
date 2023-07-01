import math.big

fn jacobsthal(n u32) big.Integer {
    mut t := big.one_int
    t=t.lshift(n)
    mut s := big.one_int
    if n%2 != 0 {
        s=s.neg()
    }
    t -= s
    return t/big.integer_from_int(3)
}

fn jacobsthal_lucas(n u32) big.Integer {
    mut t := big.one_int
    t=t.lshift(n)
    mut a := big.one_int
    if n%2 != 0 {
        a=a.neg()
    }
    return t+a
}

fn main() {
    mut jac := []big.Integer{len: 30}
    println("First 30 Jacobsthal numbers:")
    for i := u32(0); i < 30; i++ {
        jac[i] = jacobsthal(i)
        print("${jac[i]:9} ")
        if (i+1)%5 == 0 {
            println('')
        }
    }

    println("\nFirst 30 Jacobsthal-Lucas numbers:")
    for i := u32(0); i < 30; i++ {
        print("${jacobsthal_lucas(i):9} ")
        if (i+1)%5 == 0 {
            println('')
        }
    }

    println("\nFirst 20 Jacobsthal oblong numbers:")
    for i := u32(0); i < 20; i++ {
        print("${jac[i]*jac[i+1]:11} ")
        if (i+1)%5 == 0 {
            println('')
        }
    }

    /*println("\nFirst 20 Jacobsthal primes:")
    for n, count := u32(0), 0; count < 20; n++ {
        j := jacobsthal(n)
        if j.probably_prime(10) {
            println(j)
            count++
        }
    }*/
}
