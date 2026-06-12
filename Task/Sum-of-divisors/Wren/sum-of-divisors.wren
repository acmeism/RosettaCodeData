import "./math" for Int, Nums
import "./fmt" for Fmt

System.print("The sums of positive divisors for the first 100 positive integers are:")
for (i in 1..100) {
    Fmt.write("$3d   ", Nums.sum(Int.divisors(i)))
    if (i % 10 == 0) System.print()
}
