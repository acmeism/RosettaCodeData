""" Recursive Padovan """
rPadovan(n) = (n < 4) ? oneunit(n) : rPadovan(n - 3) + rPadovan(n - 2)

""" Floor function calculation Padovan """
function fPadovan(n)::Int
    p, s = big"1.324717957244746025960908854", big"1.0453567932525329623"
    return Int(floor(p^(n-2) / s + .5))
end

""" LSystem Padovan """
function list_LsysPadovan(N)
    rules = Dict("A" => "B", "B" => "C", "C" => "AB")
    seq, lens = ["A"], [1]
    for i in 1:N
        str = prod([rules[string(c)] for c in seq[end]])
        push!(seq, str)
        push!(lens, length(str))
    end
    return seq, lens
end

const lr, lf = [rPadovan(i) for i in 1:64], [fPadovan(i) for i in 1:64]
const sL, lL = list_LsysPadovan(32)
println("N  Recursive  Floor      LSystem      String\n=============================================")
foreach(i -> println(rpad(i, 4), rpad(lr[i], 12), rpad(lf[i], 12),
    rpad(i < 33 ? lL[i] : "", 12), (i < 11 ? sL[i] : "")), 1:64)
