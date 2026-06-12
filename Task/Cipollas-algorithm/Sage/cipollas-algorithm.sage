def eulerCriterion(a, p):
    return -1 if pow(a, int((p-1)/2), p) == p-1 else 1

def cipollaMult(x1, y1, x2, y2, u, p):
    return ((x1*x2 + y1*y2*u) % p), ((x1*y2 + x2*y1) % p)

def cipollaAlgorithm(n, p):
    a = Mod(n, p)
    out = []

    if eulerCriterion(a, p) == -1:
        print "❌ " + str(a) + " is not a quadratic residue modulo " + str(p)
        return False

    if not is_prime(p):
        conglst = []                                    #congruence list
        crtlst = []
        factors = []

        for k in list(factor(p)):
            factors.append(int(k[0]))

        for f in factors:
            conglst.append(cipollaAlgorithm(a, f))

        for i in Permutations([0, 1] * len(factors), len(factors)).list():
            for j in range(len(factors)):
                crtlst.append(int(conglst[ j ][ i[j] ]))

            out.append(crt(crtlst, factors))
            crtlst = []

        return sorted(out)

    if pow(p, 1, 4) == 3:
        temp = pow(a, int((p+1)/4), p)
        return [temp, p - temp]


    t = randrange(2, p)
    u = pow(t**2 - a, 1, p)
    while (eulerCriterion(u, p) == 1):
        t = randrange(2, p)
        u = pow(t**2 - a, 1, p)

    x0, y0 = t, 1
    x, y = t, 1
    for i in range(int((p + 1) / 2) - 1):
        x, y = cipollaMult(x, y, x0, y0, u, p)

    out.extend([x, p - x])

    return sorted(out)
