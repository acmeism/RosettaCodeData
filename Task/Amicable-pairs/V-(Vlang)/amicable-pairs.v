fn pfac_sum(i int) int {
    mut sum := 0
    for p := 1; p <= i / 2; p++{
        if i % p == 0 {
            sum += p
        }
    }
    return sum
}

fn main(){
    a := []int{len: 20000, init:pfac_sum(it)}
    println('The amicable pairs below 20,000 are:')
    for n in 2 .. a.len {
        m := a[n]
        if m > n && m < 20000 && n == a[m] {
            println('${n:5} and ${m:5}')
        }
    }
}
