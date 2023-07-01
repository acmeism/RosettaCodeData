# Usage: GAWK -f CHINESE_REMAINDER_THEOREM.AWK
BEGIN {
    len = split("3 5 7", n)
    len = split("2 3 2", a)
    printf("%d\n", chineseremainder(n, a, len))
}
function chineseremainder(n, a, len,    p, i, prod, sum) {
    prod = 1
    sum = 0
    for (i = 1; i <= len; i++)
        prod *= n[i]
    for (i = 1; i <= len; i++) {
        p = prod / n[i]
        sum += a[i] * mulinv(p, n[i]) * p
    }
    return sum % prod
}
function mulinv(a, b,    b0, t, q, x0, x1) {
    # returns x where (a * x) % b == 1
    b0 = b
    x0 = 0
    x1 = 1
    if (b == 1)
        return 1
    while (a > 1) {
        q = int(a / b)
        t = b
        b = a % b
        a = t
        t = x0
        x0 = x1 - q * x0
        x1 = t
    }
    if (x1 < 0)
        x1 += b0
    return x1
}
