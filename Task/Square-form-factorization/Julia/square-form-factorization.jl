function square_form_factor(n::T)::T where T <: Integer
    multiplier = T.([1, 3, 5, 7, 11, 3*5, 3*7, 3*11, 5*7, 5*11, 7*11, 3*5*7, 3*5*11, 3*7*11, 5*7*11, 3*5*7*11])
    s = T(round(sqrt(n)))
    s * s == n && return s
    for k in multiplier
        T != BigInt && n > typemax(T) ÷ k && break
        d = k * n
        p0 = pprev = p = isqrt(d)
        qprev = one(T)
        Q = d - p0 * p0
        l = T(floor(2 * sqrt(2 * s)))
        B, i = 3 * l, 2
        while i < B
            b = (p0 + p) ÷ Q
            p = b * Q - p
            q = Q
            Q = qprev + b * (pprev - p)
            r = T(round(sqrt(Q)))
            iseven(i) && r * r == Q && break
            qprev, pprev = q, p
            i += 1
        end
        i >= B && continue
        b = (p0 - p) ÷ r
        pprev = p = b * r + p
        qprev = r
        Q = (d - pprev * pprev) ÷ qprev
        i = 0
        while true
            b = (p0 + p) ÷ Q
            pprev = p
            p = b * Q - p
            q = Q
            Q = qprev + b * (pprev - p)
            qprev = q
            i += 1
            p == pprev && break
        end
        r = gcd(n, qprev)
        r != 1 && r != n && return r
    end
    return zero(T)
end

println("Integer              Factor   Quotient\n", "-"^45)
@time for n in Int128.([
    2501, 12851, 13289, 75301, 120787, 967009, 997417, 7091569, 13290059, 42854447, 223553581,
    2027651281, 11111111111, 100895598169, 1002742628021, 60012462237239, 287129523414791,
    9007199254740931, 11111111111111111, 314159265358979323, 384307168202281507, 419244183493398773,
    658812288346769681, 922337203685477563, 1000000000000000127, 1152921505680588799,
    1537228672809128917, 4611686018427387877])
    print(rpad(n, 22))
    factr = square_form_factor(n)
    print(rpad(factr, 10))
    println(factr == 0 ? "fail" : n ÷ factr)
end
