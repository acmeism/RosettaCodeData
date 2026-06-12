import "./math" for Int, Nums
import "./fmt" for Fmt

Fmt.print("The sum of all primes below 2 million is $,d.", Nums.sum(Int.primeSieve(2e6-1)))
