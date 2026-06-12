function sturmian_word(m, n)
    m > n && return replace(sturmian_word(n, m), '0' => '1', '1' => '0')
    res = ""
    k, prev = 1, 0
    while rem(k * m, n) > 0
        curr = (k * m) ÷ n
        res *= prev == curr ? "0" : "10"
        prev = curr
        k += 1
    end
    return res
end

function fibWord(n)
    Sn_1, Sn, tmp = "0", "01", ""
    for _ in 2:n
        tmp = Sn
        Sn *= Sn_1
        Sn_1 = tmp
    end
    return Sn
end

const fib = fibWord(7)
const sturmian = sturmian_word(13, 21)
@assert fib[begin:length(sturmian)] == sturmian
println(" $sturmian <== 13/21")

""" return the kth convergent """
function cfck(a, b, m, n, k)
    p = [0, 1]
    q = [1, 0]
    r = (sqrt(a) * b + m) / n
    for _ in 1:k
        whole = Int(trunc(r))
        pn = whole * p[end] + p[end-1]
        qn = whole * q[end] + q[end-1]
        push!(p, pn)
        push!(q, qn)
        r = 1/(r - whole)
    end
    return [p[end], q[end]]
end

println(" $(sturmian_word(cfck(5, 1, -1, 2, 8)...)) <== 1/phi (8th convergent golden ratio)")
