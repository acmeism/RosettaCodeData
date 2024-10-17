function calkin_wilf(n)
    cw = zeros(Rational, n + 1)
    for i in 2:n + 1
        t = Int(floor(cw[i - 1])) * 2 - cw[i - 1] + 1
        cw[i] = 1 // t
    end
    return cw[2:end]
end

function continued(r::Rational)
    a, b = r.num, r.den
    res = []
    while true
        push!(res, Int(floor(a / b)))
        a, b = b, a % b
        a == 1 && break
    end
    return res
end

function term_number(cf)
    b, d = "", "1"
    for n in cf
        b = d^n * b
        d = (d == "1") ? "0" : "1"
    end
    return parse(Int, b, base=2)
end

const cw = calkin_wilf(20)
println("The first 20 terms of the Calkin-Wilf sequence are: $cw")

const r = 83116 // 51639
const cf = continued(r)
const tn = term_number(cf)
println("$r is the $tn-th term of the sequence.")
