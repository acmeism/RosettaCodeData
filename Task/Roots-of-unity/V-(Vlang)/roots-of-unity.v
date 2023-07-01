import math

for n in 2..6 {
    print("${n}: ")
    for root in 0..n {
        real := math.cos(2 * 3.14 * root/n)
        imag := math.sin(2 * 3.14 * root/n)
        print("${real:.4} ${imag:.4}i")
        if root != n - 1 {print(", ")}
    }
    println("")
}
