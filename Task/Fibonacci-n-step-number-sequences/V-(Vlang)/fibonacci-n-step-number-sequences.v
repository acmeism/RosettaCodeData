fn fib_n(initial []int, num_terms int) []int {
    n := initial.len
    if n < 2 || num_terms < 0 {panic("Invalid argument(s).")}
    if num_terms <= n {return initial}
    mut fibs := []int{len:num_terms}
    for i in 0..n {
        fibs[i] = initial[i]
    }
    for i in n..num_terms {
        mut sum := 0
        for j in i-n..i {
            sum = sum + fibs[j]
        }
        fibs[i] = sum
    }
    return fibs
}

fn main(){
    names := [
        "fibonacci",  "tribonacci", "tetranacci", "pentanacci", "hexanacci",
        "heptanacci", "octonacci",  "nonanacci",  "decanacci"
    ]
    initial := [1, 1, 2, 4, 8, 16, 32, 64, 128, 256]
    println(" n  name         values")
    mut values := fib_n([2, 1], 15)
    print(" 2  ${'lucas':-10}")
    println(values.map('${it:4}').join(' '))
    for i in 0..names.len {
        values = fib_n(initial[0..i + 2], 15)
        print("${i+2:2}  ${names[i]:-10}")
        println(values.map('${it:4}').join(' '))
    }
}
