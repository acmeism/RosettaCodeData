MOD = 2
def fp(a, k):
    return pow(a, k, MOD)
def berlekamp_massey(a):
    n = len(a) - 1
    ans_coef = []
    lst = []
    w = 0
    delta = 0
    for i in range(1, n + 1):
        tmp = 0
        for j in range(len(ans_coef)):
            if i - 1 - j >= 1:
                tmp = (tmp + a[i - 1 - j] * ans_coef[j]) % MOD
        discrepancy = (a[i] - tmp + MOD) % MOD
        if discrepancy == 0:
            continue
        if w == 0:
            ans_coef = [0] * i
            w = i
            delta = discrepancy
            continue
        now = list(ans_coef)
        mul = discrepancy * fp(delta, MOD - 2) % MOD
        needed_len = len(lst) + i - w
        if len(ans_coef) < needed_len:
            ans_coef.extend([0] * (needed_len - len(ans_coef)))
        if i - w - 1 >= 0:
            ans_coef[i - w - 1] = (ans_coef[i - w - 1] + mul) % MOD
        for j in range(len(lst)):
            idx = i - w + j
            if idx < len(ans_coef):
                term_to_subtract = (mul * lst[j]) % MOD
                ans_coef[idx] = (ans_coef[idx] - term_to_subtract + MOD) % MOD
        if len(ans_coef) > len(now):
            lst = now
            w = i
            delta = discrepancy
    return [(x + MOD) % MOD for x in ans_coef]
def calculate_term(m, coef, h):
    k = len(coef)
    if m < len(h):
        return (h[m] + MOD) % MOD
    if k == 0:
        return 0
    p_coeffs = [0] * (k + 1)
    p_coeffs[0] = (MOD - 1) % MOD
    for i in range(k):
        p_coeffs[i + 1] = coef[i]
    def poly_mul(a, b, degree_k, p_poly):
        res = [0] * (2 * degree_k)
        for i in range(degree_k):
            if a[i] == 0: continue
            for j in range(degree_k):
                res[i + j] = (res[i + j] + a[i] * b[j]) % MOD
        for i in range(2 * degree_k - 1, degree_k - 1, -1):
            if res[i] == 0: continue
            term = res[i]
            res[i] = 0
            for j in range(degree_k + 1):
                idx = i - j
                if idx >= 0:
                    res[idx] = (res[idx] + term * p_poly[j]) % MOD
        return res[:degree_k]
    f = [0] * k
    g = [0] * k
    f[0] = 1
    if k == 1:
        if k == 1:
            g[0] = p_coeffs[1]
        else:
            g[1] = 1
    else:
        g[1] = 1
    power = m
    while power > 0:
        if power & 1:
            f = poly_mul(f, g, k, p_coeffs)
        g = poly_mul(g, g, k, p_coeffs)
        power >>= 1
    final_ans = 0
    for i in range(k):
        if i + 1 < len(h):
            final_ans = (final_ans + h[i + 1] * f[i]) % MOD
    return (final_ans + MOD) % MOD
def solve():
    h_input = [0,0,1,1,0,1,0]
    n=len(h_input)
    h = [0] + h_input
    ans_coef = berlekamp_massey(h)
    print(*((x + MOD) % MOD for x in ans_coef))
    # m=10
    # result = calculate_term(m, ans_coef, h)
    # print((result + MOD) % MOD)
if __name__ == "__main__":
    solve()
