import "./math" for Int
import "./fmt" for Fmt

var res = [1]
var count = 1
var i = 2
var lim1 = 100
var lim2 = 1000
var max = 1e7
while (count < max) {
    var cubeFree = false
    var factors = Int.primeFactors(i)
    if (factors.count < 3) {
        cubeFree = true
    } else {
        cubeFree = true
        for (i in 2...factors.count) {
            if (factors[i-2] == factors[i-1] && factors[i-1] == factors[i]) {
                cubeFree = false
                break
            }
        }
    }
    if (cubeFree) {
        if (count < lim1) res.add(factors[-1])
        count = count + 1
        if (count == lim1) {
            System.print("First %(lim1) terms of a[n]:")
            Fmt.tprint("$3d", res, 10)
        } else if (count == lim2) {
            Fmt.print("\nThe $,r term of a[n] is $,d.", count, factors[-1])
            lim2 = lim2 * 10
        }
    }
    i = i + 1
    if (i % 8 == 0 || i % 27 == 0) i = i + 1
}
