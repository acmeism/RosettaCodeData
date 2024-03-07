import "./math" for Int
import "./fmt" for Fmt

class CP {
    // Return the Cyclotomic Polynomial of order 'cpIndex' as a list of coefficients,
    // where, for example, the polynomial 3x^2 - 1 is represented by the list [3, 0, -1].
    static cycloPoly(cpIndex) {
        var polynomial = [1, -1]
        if (cpIndex == 1) return polynomial
        if (Int.isPrime(cpIndex)) return List.filled(cpIndex, 1)
        var primes = Int.distinctPrimeFactors(cpIndex)
        var product = 1
        for (prime in primes) {
            var numerator = substituteExponent(polynomial, prime)
            polynomial = exactDivision(numerator, polynomial)
            product = product * prime
        }
        return substituteExponent(polynomial, Int.quo(cpIndex, product))
    }

    // Return the Cyclotomic Polynomial obtained from 'polynomial'
    // by replacing x with x^'exponent'.
    static substituteExponent(polynomial, exponent) {
        var result = List.filled(exponent * (polynomial.count - 1) + 1, 0)
        for (i in polynomial.count-1..0) result[i*exponent] = polynomial[i]
        return result
    }

    // Return the Cyclotomic Polynomial equal to 'dividend' / 'divisor'.
    // The division is always exact.
    static exactDivision(dividend, divisor) {
        var result = dividend.toList
        for (i in 0..dividend.count - divisor.count) {
            if (result[i] != 0) {
                for (j in 1...divisor.count) {
                    result[i+j] = result[i+j] - divisor[j] * result[i]
                }
            }
        }
        return result[0..result.count - divisor.count]
    }

    // Return whether 'polynomial' has a coefficient of equal magnitude
    // to 'coefficient'.
    static hasHeight(polynomial, coefficient) {
        for (i in 0..Int.quo(polynomial.count + 1, 2)) {
            if (polynomial[i].abs == coefficient) return true
        }
        return false
    }
}

System.print("Task 1: Cyclotomic polynomials for n <= 30:")
for (cpIndex in 1..30) {
    Fmt.write("CP[$2d] = ", cpIndex)
    Fmt.pprint("$d", CP.cycloPoly(cpIndex), "", "x")
}

System.print("\nTask 2: Smallest cyclotomic polynomial with n or -n as a coefficient:")
System.print("CP[    1] has a coefficient with magnitude 1")
var cpIndex = 2
for (coeff in 2..10) {
    while (Int.isPrime(cpIndex) || !CP.hasHeight(CP.cycloPoly(cpIndex), coeff)) {
        cpIndex = cpIndex + 1
    }
    Fmt.print("CP[$5d] has a coefficient with magnitude $d", cpIndex, coeff)
}
