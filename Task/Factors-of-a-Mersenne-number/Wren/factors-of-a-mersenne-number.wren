import "/math" for Int
import "/fmt" for Conv, Fmt

var trialFactor = Fn.new { |base, exp, mod|
    var square = 1
    var bits = Conv.itoa(exp, 2).toList
    var ln = bits.count
    for (i in 0...ln) {
        square = square * square * (bits[i] == "1" ? base : 1) % mod
    }
    return square == 1
}

var mersenneFactor = Fn.new { |p|
    var limit = (2.pow(p) - 1).sqrt.floor
    var k = 1
    while ((2*k*p - 1) < limit) {
        var q = 2*k*p + 1
        if (Int.isPrime(q) && (q%8 == 1 || q%8 == 7) && trialFactor.call(2, p, q)) {
            return q  // q is a factor of 2^p - 1
        }
        k = k + 1
    }
    return null
}

var m = [3, 5, 11, 17, 23, 29, 31, 37, 41, 43, 47, 53, 59, 67, 71, 73, 79, 83, 97, 929]
for (p in m) {
    var f = mersenneFactor.call(p)
    Fmt.write("2^$3d - 1 is ", p)
    if (f) {
        Fmt.print("composite (factor $d)", f)
    } else {
        System.print("prime")
    }
}
