/* Parallel_calculations.wren */

import "./math" for Int

class C {
    static minPrimeFactor(n)  { Int.primeFactors(n)[0] }

    static allPrimeFactors(n) { Int.primeFactors(n) }
}
