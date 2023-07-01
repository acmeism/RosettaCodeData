fn reduce(mut a []int){
    mut last := 0
    for e in a {
        if e%2==0 {
            a[last] = e
            last++
        }
    }
    a = a[..last]
}
fn main() {
    mut nums := [5,4,8,2,4,6,5,6,34,12,21]
    even := nums.filter(it%2==0)
    println('orig: $nums')
    println('even: $even')
    reduce(mut nums)
    println('dest: $nums')
}
