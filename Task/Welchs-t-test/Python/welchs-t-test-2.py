import math

def betain(x, p, q):
    if p <= 0 or q <= 0 or x < 0 or x > 1:
        raise ValueError

    if x == 0 or x == 1:
        return x

    acu = 1e-15
    lnbeta = math.lgamma(p) + math.lgamma(q) - math.lgamma(p + q)

    psq = p + q
    if p < psq * x:
        xx = 1 - x
        cx = x
        pp = q
        qq = p
        indx = True
    else:
        xx = x
        cx = 1 - x
        pp = p
        qq = q
        indx = False

    term = ai = value = 1
    ns = math.floor(qq + cx * psq)
    rx = xx / cx
    temp = qq - ai
    if ns == 0:
        rx = xx

    while True:
        term *= temp * rx / (pp + ai)
        value += term
        temp = abs(term)

        if temp <= acu and temp <= acu * value:
            value *= math.exp(pp * math.log(xx) + (qq - 1) * math.log(cx) - lnbeta) / pp
            return 1 - value if indx else value

        ai += 1
        ns -= 1
        if ns >= 0:
            temp = qq - ai
            if ns == 0:
                rx = xx
        else:
            temp = psq
            psq += 1
