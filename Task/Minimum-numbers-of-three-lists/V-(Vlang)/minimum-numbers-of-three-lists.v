import math
fn main() {
    numbers1 := [5, 45, 23, 21, 67]!
    numbers2 := [43, 22, 78, 46, 38]!
    numbers3 := [9, 98, 12, 98, 53]!
    mut numbers := [5]int{}
    for n in 0..5 {
        numbers[n] = math.min<int>(math.min<int>(numbers1[n], numbers2[n]), numbers3[n])
    }
    println(numbers)
}
