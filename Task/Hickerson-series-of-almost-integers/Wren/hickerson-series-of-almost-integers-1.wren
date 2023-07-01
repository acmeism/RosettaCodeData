import "/math" for Int
import "/fmt" for Fmt
import "/big" for BigInt

var hickerson = Fn.new { |n|
    var fact = BigInt.new(Int.factorial(n)) // accurate up to n == 18
    var ln2 = BigInt.new("693147180559945309417232121458176568075500134360255254120680009") // 63 digits
    var mult = BigInt.new("1e64").pow(n+1)  // 64 == ln2 digit count + 1
    return fact * mult /(BigInt.two * ln2.pow(n+1))
}

System.print("Values of h(n), truncated to 1 dp, and whether 'almost integers' or not:")
for (i in 1..17) {
    var h = hickerson.call(i).toString
    var hl = h.count
    var k = hl - i - 1
    var ai = (h[k] == "0" || h[k] == "9")
    var s = h[0...k] + "." + h[k]
    Fmt.print("$2d: $20s $s", i, s, ai)
}
