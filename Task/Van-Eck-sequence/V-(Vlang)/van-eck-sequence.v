fn main() {
    max := 1000
    mut a := []int{len: max} // all zero by default
    for n in 0..max-1 {
        for m := n - 1;  m >= 0; m-- {
            if a[m] == a[n] {
                a[n+1] = n - m
                break
            }
        }
    }
    println("The first ten terms of the Van Eck sequence are:")
    println(a[..10])
    println("\nTerms 991 to 1000 of the sequence are:")
    println(a[990..])
}
