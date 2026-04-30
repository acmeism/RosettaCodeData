fn is_prime(num int) bool {
    if num <= 1 {return false }
    if num % 2 == 0 && num != 2 { return false }
    for i := 3; i <= (num / 2) - 1; i += 2 {
        if num % i == 0 { return false }
    }
    return true
}

fn decomp(nr int) {
    mut x := ""
    for i := 1; i <= nr; i++ {
        if is_prime(i) && nr % i == 0 { x += "${i} * " }
    }
    if x.len > 2 {
        x2 := x[..x.len - 3] // Remove last " * "
        println("${nr} = ${x2}")
    } else {
        println("${nr} has no prime factors")
    }
}

fn main() {
    prime := 18705
    decomp(prime)
}
