import "./math" for Int, Nums
import "./fmt" for Fmt

System.print("The products of positive divisors for the first 50 positive integers are:")
for (i in 1..50) {
    Fmt.write("$9d  ", Nums.prod(Int.divisors(i)))
    if (i % 5 == 0) System.print()
}
