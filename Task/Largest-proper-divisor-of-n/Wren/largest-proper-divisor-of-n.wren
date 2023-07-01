import "/math" for Int
import "/fmt" for Fmt

System.print("The largest proper divisors for numbers in the interval [1, 100] are:")
System.write(" 1  ")
for (n in 2..100) {
    if (n % 2 == 0) {
        Fmt.write("$2d  ", n / 2)
    } else {
        Fmt.write("$2d  ", Int.properDivisors(n)[-1])
    }
    if (n % 10 == 0) System.print()
}
