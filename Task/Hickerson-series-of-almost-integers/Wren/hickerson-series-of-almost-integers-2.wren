import "/math" for Int
import "/fmt" for Fmt
import "/big" for BigRat

var hickerson = Fn.new { |n|
    var fact = BigRat.new(Int.factorial(n))
    var ln2 = BigRat.fromDecimal("0.693147180559945309417232121458176568075500134360255254120680009")
    return fact / (BigRat.two * ln2.pow(n+1))
}

System.print("Values of h(n), truncated to 1 dp, and whether 'almost integers' or not:")
for (i in 1..17) {
    var h = hickerson.call(i).toDecimal(1, false)
    var hl = h[-1]
    var ai = (hl == "0" || hl == "9")
    Fmt.print("$2d: $20s $s", i, h, ai)
}
