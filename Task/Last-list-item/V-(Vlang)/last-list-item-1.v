fn main() {
    mut a := [6, 81, 243, 14, 25, 49, 123, 69, 11]
    for a.len > 1 {
        a.sort()
        println("Sorted list: $a")
        sum := a[0] + a[1]
        println("Two smallest: ${a[0]} + ${a[1]} = $sum")
        a << sum
        a = a[2..].clone()
    }
    println("Last item is ${a[0]}.")
}
