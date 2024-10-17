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
        a1, a2 = a2, a1 - BigInt(round(q)) * a2
    end
    if dot(a1, a1) < N
        return (Rational{Int}(a1[1]) // Rational{Int}(a1[2])) // Int(den)
    else
        return Int(r) // den
    end
end

function dstring(pa::padic)
    u, v, n, p, k = pa.u, pa.v, pa.N, pa.parent.p, pa.parent.prec_max
    d = digits(v > 0 ? u * p^v : u, base=pa.parent.p, pad=k)
    return prod([i == k + v && v != 0 ? "$x . " : "$x " for (i, x) in enumerate(reverse(d))])
end

const DATA = [
    [2, 1, 2, 4, 1, 1],
    [4, 1, 2, 4, 3, 1],
    [4, 1, 2, 5, 3, 1],
    [4, 9, 5, 4, 8, 9],
    [26, 25, 5, 4, -109, 125],
    [49, 2, 7, 6, -4851, 2],
    [-9, 5, 3, 8, 27, 7],
    [5, 19, 2, 12, -101, 384],

    # Base 10 10-adic p-adics are not allowed by Nemo library -- p must be a prime

    # familiar digits
    [11, 4, 2, 43, 679001, 207],
    [-8, 9, 23, 9, 302113, 92],
    [-22, 7, 3, 23, 46071, 379],
    [-22, 7, 32749, 3, 46071, 379],
    [35, 61, 5, 20, 9400, 109],
    [-101, 109, 61, 7, 583376, 6649],
    [-25, 26, 7, 13, 5571, 137],
    [1, 4, 7, 11, 9263, 2837],
    [122, 407, 7, 11, -517, 1477],
    # more subtle
    [5, 8, 7, 11, 353, 30809],
]

for (num1, den1, P, K, num2, den2) in DATA
    Qp = PadicField(P, K)
    a = Qp(QQ(num1 // den1))
    b = Qp(QQ(num2 // den2))
    c = a + b
    r = toRational(c)
    println(a, "\n", dstring(a), "\n", b, "\n", dstring(b), "\n+ =\n", c, "\n", dstring(c), "   $r\n")
end
