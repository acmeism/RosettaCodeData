import "./math" for Int
import "./fmt" for Fmt

System.print("The tau functions for the first 100 positive integers are:")
for (i in 1..100) {
    Fmt.write("$2d  ", Int.divisors(i).count)
    if (i % 20 == 0) System.print()
}
