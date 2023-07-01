var deficients = 0 // sumPd < n
var perfects = 0 // sumPd = n
var abundants = 0 // sumPd > n

// 1 is deficient (no proper divisor)
deficients++


for i in 2...20000 {

    var sumPd = 1 // 1 is a proper divisor of all integer above 1

    var maxPdToTest = i/2 // the max divisor to test

    for var j = 2; j < maxPdToTest; j++ {

        if (i%j) == 0 {
            // j is a proper divisor
            sumPd += j

            // New maximum for divisibility check
            maxPdToTest = i / j

            // To add to sum of proper divisors unless already done
            if maxPdToTest != j {
                sumPd += maxPdToTest
            }
        }
    }

    // Select type according to sum of Proper divisors
    if sumPd < i {
        deficients++
    } else if sumPd > i {
        abundants++
    } else {
        perfects++
    }
}

println("There are \(deficients) deficient, \(perfects) perfect and \(abundants) abundant integers from 1 to 20000.")
