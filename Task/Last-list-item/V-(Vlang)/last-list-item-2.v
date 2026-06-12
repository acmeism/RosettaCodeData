fn find_min(a []int) (int, int) {
    mut ix := 0
    mut min := a[0]
    for i in 1..a.len {
        if a[i] < min {
            ix = i
            min = a[i]
        }
    }
    return min, ix
}
fn main() {
    mut a := [6, 81, 243, 14, 25, 49, 123, 69, 11]
    for a.len > 1 {
        println("List: $a")
        mut s := [2]int{}
        for i in 0..2 {
            min, ix := find_min(a)
            s[i] = min
            a.delete(ix)
        }
        sum := s[0] + s[1]
        println("Two smallest: ${s[0]} + ${s[1]} = $sum")
        a << sum
    }
    println("Last item is ${a[0]}.")
}
