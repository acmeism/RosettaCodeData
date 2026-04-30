import strconv

fn is_prime(n int) bool {
    if n <= 1 { return false }
    for i := 2; i * i <= n; i++ {
        if n % i == 0 { return false }
    }
    return true
}

fn main() {
    mut row := 0
    limit := 500	
    println("working...")
    println("Additive primes are:")
    for n := 1; n <= limit; n++ {
        if is_prime(n) {
            strn := n.str()
            mut num := 0
            for ch in strn {
                digit := strconv.atoi(ch.ascii_str()) or { exit(1) }
                num += digit
            }
            if is_prime(num) {
                row++
                print("$n ")
                if row % 10 == 0 { println("") }
            }
        }
    }
    println("")
    println("found $row additive primes.")
    println("done...")
}
