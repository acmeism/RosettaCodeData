import "/math" for Int
import "/fmt" for Fmt

var wilson = Fn.new { |p|
    if (p < 2) return false
    return (Int.factorial(p-1) + 1) % p == 0
}

for (p in 1..19) {
    Fmt.print("$2d -> $s", p, wilson.call(p) ? "prime" : "not prime")
}
