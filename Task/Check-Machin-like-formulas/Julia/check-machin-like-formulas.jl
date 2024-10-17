using AbstractAlgebra # implements arbitrary precision rationals

tanplus(x,y) = (x + y) / (1 - x * y)

function taneval(coef, frac)
    if coef == 0
        return 0
    elseif coef < 0
        return -taneval(-coef, frac)
    elseif isodd(coef)
        return tanplus(frac, taneval(coef - 1, frac))
    else
        x = taneval(div(coef, 2), frac)
        return tanplus(x, x)
    end
end

taneval(tup::Tuple) = taneval(tup[1], tup[2])

tans(v::Vector{Tuple{BigInt, Rational{BigInt}}}) = foldl(tanplus, map(taneval, v), init=0)

const testmats = Dict{Vector{Tuple{BigInt, Rational{BigInt}}}, Bool}([
    ([(1, 1//2), (1, 1//3)], true), ([(2, 1//3), (1, 1//7)], true),
    ([(12, 1//18), (8, 1//57), (-5, 1//239)], true),
    ([(88, 1//172), (51, 1//239), (32, 1//682), (44, 1//5357), (68, 1//12943)], true),
    ([(88, 1//172), (51, 1//239), (32, 1//682), (44, 1//5357), (68, 1//12944)], false)])


function runtestmats()
    println("Testing matrices:")
    for (k, m) in testmats
        ans = tans(k)
        println((ans == 1) == m ? "Verified as $m: " : "Not Verified as $m: ", "tan $k = $ans")
    end
end

runtestmats()
