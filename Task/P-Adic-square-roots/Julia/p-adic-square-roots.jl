using Nemo, LinearAlgebra

set_printing_mode(FlintPadicField, :terse)

""" convert to Rational (rational reconstruction) """
function toRational(pa::padic)
    rat = lift(QQ, pa)
    r, den = BigInt(numerator(rat)), Int(denominator(rat))
    p, k = Int(prime(parent(pa))), Int(precision(pa))
    N = BigInt(p^k)
    a1, a2 = [N, 0], [r, 1]
    while dot(a1, a1) > dot(a2, a2)
        q = dot(a1, a2) // dot(a2, a2)
        a1, a2 = a2, a1 - round(q) * a2
    end
    if dot(a1, a1) < N
        return (Rational{Int}(a1[1]) // Rational{Int}(a1[2])) // Int(den)
    else
        return Int(r) // den
    end
end

function dstring(pa::padic)
    u, v, n, p, k = pa.u, pa.v, pa.N, pa.parent.p, pa.parent.prec_max
    d = digits(v > 0 ? u * p^v : u, base=p, pad=k)
    return prod([i == k + v && v != 0 ? "$x . " : "$x " for (i, x) in enumerate(reverse(d))])
end

const DATA = [
    [-7, 1, 2, 7],
    [9, 1, 2, 8],
    [17, 1, 2, 9],
    [-1,  1,  5, 8],
    [86, 25,  5, 8],
    [2150, 1,  5, 8],
    [2, 1, 7, 8],
    [3029, 4821, 7, 9],
    [379, 449, 7, 8],
    [717, 8, 11, 7],
    [1414, 213, 41, 5],
    [-255, 256, 257, 3]
]

for (num1, den1, P, K) in DATA
    Qp = PadicField(P, K)
    a = Qp(QQ(num1 // den1))
    c = sqrt(a)
    r = toRational(c * c)
    println(a, "\nsqrt +/-\n", dstring(c), "\n", dstring(-c), "\nCheck sqrt^2:\n", dstring(c * c), "\n", r, "\n")
end
