import math

// an `is_prime` method can also be imported from the vsl module (v install vsl)
fn is_prime(num int) bool {
    if num < 2 { return false }
    if num == 2 { return true }
    if num % 2 == 0 { return false }
    for i := 3; i <= int(math.sqrt(f64(num))); i += 2 {
        if num % i == 0 { return false }
    }
    return true
}

fn main() {
    println("work...")
    for n := 3; n <= 10_000_000; n += 2 {
        n1 := n
        n2 := n + 2
        if is_prime(n1) && is_prime(n2) {
            sum := n1 + n2
            root := math.sqrt(f64(sum))
			// convert numbers to string
            if root == math.ceil(root) { println("$n1 + $n2 = ${int(root)} * ${int(root)}") }
        }
    }
    println("done...")
}
