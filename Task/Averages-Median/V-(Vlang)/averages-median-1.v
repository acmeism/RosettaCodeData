fn main() {
    println(median([3, 1, 4, 1]))    // prints 2
    println(median([3, 1, 4, 1, 5])) // prints 3
}

fn median(aa []int) int {
    mut a := aa.clone()
    a.sort()
    half := a.len / 2
    mut m := a[half]
    if a.len%2 == 0 {
        m = (m + a[half-1]) / 2
    }
    return m
}
