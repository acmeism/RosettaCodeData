import std

def extended_gcd(a, b):
    var s = 0
    var old_s = 1
    var t = 1
    var old_t = 0
    var r = b
    var old_r = a

    while r != 0:
        let quotient = old_r / r
        old_r, r = r, old_r - quotient * r
        old_s, s = s, old_s - quotient * s
        old_t, t = t, old_t - quotient * t

    return old_r, old_s, old_t, t, s

def for2(xs, ys, fun): return for xs.length: fun(xs[_], ys[_])

def crt(xs, ys):
    let p = reduce(xs): _a * _b
    var r = 0
    for2(xs,ys) x, y:
        let q = p / x
        let z,s,_t,_qt,_qs = q.extended_gcd(x)
        if z != 1:
            return "ng " + x + " not coprime", 0
        if s < 0: r += y * (s + x) * q
        else:     r += y * s       * q
    return "ok", r % p


def print_crt(xs, ys):
    let msg, res = crt(xs, ys)
    print(msg + " " + res)

print_crt([3,5,7],[2,3,2])
print_crt([11,12,13],[10,4,12])
print_crt([11,22,19],[10,4,9])
print_crt([100,23],[19,0])
