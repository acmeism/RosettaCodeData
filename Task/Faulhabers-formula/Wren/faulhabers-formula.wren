import "/math" for Int
import "/rat" for Rat

var bernoulli = Fn.new { |n|
    if (n < 0) Fiber.abort("Argument must be non-negative")
    var a = List.filled(n+1, null)
    for (m in 0..n) {
        a[m] = Rat.new(1, m+1)
        var j = m
        while (j >= 1) {
            a[j-1] = (a[j-1] - a[j]) * Rat.new(j, 1)
            j = j - 1
        }
    }
    return (n != 1) ? a[0] : -a[0] // 'first' Bernoulli number
}

var binomial = Fn.new { |n, k|
    if (n < 0 || k < 0) Fiber.abort("Arguments must be non-negative integers")
    if (n < k) Fiber.abort("The second argument cannot be more than the first.")
    if (n == k) return 1
    var prod = 1
    var i = n - k + 1
    while (i <= n) {
        prod = prod * i
        i = i + 1
    }
    return prod / Int.factorial(k)
}

var faulhaber = Fn.new { |p|
    System.write("%(p) : ")
    var q = Rat.new(1, p+1)
    var sign = -1
    for (j in 0..p) {
        sign = sign * -1
        var b = Rat.new(binomial.call(p+1, j), 1)
        var coeff = q * Rat.new(sign, 1) * b * bernoulli.call(j)
        if (coeff != Rat.zero) {
            if (j == 0) {
                System.write((coeff == Rat.one) ? "" : (coeff == Rat.minusOne) ? "-" : "%(coeff)")
            } else {
                System.write((coeff == Rat.one) ? " + " : (coeff == Rat.minusOne) ? " - " :
                             (coeff > Rat.zero) ? " + %(coeff)" : " - %(-coeff)")
            }
            var pwr = p + 1 - j
            System.write((pwr > 1) ? "n^%(pwr)" : "n")
        }
    }
    System.print()
}

for (i in 0..9) faulhaber.call(i)
