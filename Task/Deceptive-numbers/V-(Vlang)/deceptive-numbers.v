import math.big

fn is_prime(n int) bool {
    if n < 2 {return false}
	else if n % 2 == 0 {return n == 2}
	else if n % 3 == 0 {return n == 3}
	else {
        mut d := 5
        for d * d <= n {
            if n % d == 0 {return false}
            d += 2
            if n % d == 0 {return false}
            d += 4
        }
        return true
    }
}

fn main() {
    mut count := 0
    limit := 25
    mut n := i64(17)
    mut repunit := big.integer_from_i64(1111111111111111)
    mut t := big.integer_from_int(0)
    zero := big.integer_from_int(0)
    eleven := big.integer_from_int(11)
    hundred := big.integer_from_int(100)
    mut deceptive := []i64{}
    for count < limit {
        if !is_prime(int(n)) && n % 3 != 0 && n % 5 != 0 {
            bn := big.integer_from_i64(n)
            t = repunit % bn
            if t == zero {
                deceptive << n
                count++
            }
        }
        n += 2
        repunit = repunit * hundred
        repunit = repunit + eleven
    }
    println("The first $limit deceptive numbers are:")
    println(deceptive)
}
