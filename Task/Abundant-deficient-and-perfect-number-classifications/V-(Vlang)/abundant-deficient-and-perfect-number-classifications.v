fn p_fac_sum(i int) int {
    mut sum := 0
    for p := 1; p <= i/2; p++ {
        if i%p == 0 {
            sum += p
        }
    }
    return sum
}

fn main() {
    mut d := 0
    mut a := 0
    mut p := 0
    for i := 1; i <= 20000; i++ {
        j := p_fac_sum(i)
        if j < i {
            d++
        } else if j == i {
            p++
        } else {
            a++
        }
    }
    println("There are $d deficient numbers between 1 and 20000")
    println("There are $a abundant numbers  between 1 and 20000")
    println("There are $p perfect numbers between 1 and 20000")
}
