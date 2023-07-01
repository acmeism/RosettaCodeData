fn max<T>(list []T) T {
    mut max := list[0]
    for i in 1..list.len {
        if list[i] > max {
            max = list[i]
        }
    }
    return max
}
fn main() {
    println('int max: ${max<int>([5,6,4,2,8,3,0,2])}')
    println('float max: ${max<f64>([1e4, 1e5, 1e2, 1e9])}')
}
