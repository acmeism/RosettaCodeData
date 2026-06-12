const MOD = 2

fp(a, k) = powermod(a, k, MOD)

function berlekampmassey(a::Vector{T}) where T
    n, w, delta = length(a) - 1, zero(T), zero(T)
    ans_coef, lst = T[], T[]
    for i in 2:n+1
        tmp = zero(T)
        for j in eachindex(ans_coef)
            if i - j >= 1
                tmp = (tmp + a[i - j] * ans_coef[j]) % MOD
            end
        end
        discrepancy = (a[i] - tmp + MOD) % MOD
        discrepancy == 0 && continue
        if w == 0
            ans_coef = zeros(T, i)
            w = i
            delta = discrepancy
            continue
        end
        now = copy(ans_coef)
        mul = discrepancy * fp(delta, MOD - 2) % MOD
        needed_len = length(lst) + i - w
        if length(ans_coef) < needed_len
            append!(ans_coef, zeros(T, needed_len - length(ans_coef)))
        end
        if i - w > 0
            ans_coef[i - w] = (ans_coef[i - w] + mul) % MOD
        end
        for j in eachindex(lst)
            idx = i - w + j
            if idx < length(ans_coef)
                term_to_subtract = (mul * lst[j]) % MOD
                ans_coef[idx] = (ans_coef[idx] - term_to_subtract + MOD) % MOD
            end
        end
        if length(ans_coef) > length(now)
            lst = now
            w = i
            delta = discrepancy
        end
    end
    return map(k -> (k + MOD) % MOD, ans_coef)
end

function poly_mul(a::Vector{T}, b, degree_k, p_poly) where T
    res = zeros(T, 2 * degree_k)
    for i in 1:degree_k
        a[i] == 0 && continue
        for j in 1:degree_k
            res[i + j - 1] = (res[i + j - 1] + a[i] * b[j]) % MOD
        end
    end
    for i in 2*degree_k:-1:degree_k-1
        res[i] == 0 && continue
        term = res[i]
        res[i] = 0
        for j in 1:degree_k
            idx = i - j + 1
            if idx > 0
                res[idx] = (res[idx] + term * p_poly[j]) % MOD
            end
        end
    end
    return res # [begin:degree_k-1]
end

function calculate_term(m, coef::Vector{T}, h) where T
    isempty(coef) && return 0
    m <= length(h) && return (h[m] + MOD) % MOD
    k = length(coef)
    p_coeffs = [(MOD - 1) % MOD; coef]
    f = zeros(T, k)
    g = zeros(T, k)
    f[begin] = 1
    if k == 1
        g[begin] = p_coeffs[begin+1]
    else
        g[begin+1] = 1
    end
    while m > 0
        if isodd(m)
            f = poly_mul(f, g, k, p_coeffs)
        end
        g = poly_mul(g, g, k, p_coeffs)
        m >>= 1
    end
    final_ans = 0
    for i in 1:k
        if i < length(h)
            final_ans = (final_ans + h[i + 1] * f[i]) % MOD
        end
    end
    return (final_ans + MOD) % MOD
end

import Polynomials.Polynomial

function solve()
    h_input = [0,0,1,1,0,1,0]
    h = [0; h_input]
    ans_coef = berlekampmassey(h)
    println("Coefficients (reverse order) in Z($MOD) are $ans_coef, so polynomial is ", Polynomial(ans_coef))
end

solve()
