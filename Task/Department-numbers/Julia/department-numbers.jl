using Printf

function findsolution(rng=1:7)
    rst = Matrix{Int}(0, 3)
    for p in rng, f in rng, s in rng
        if p != s != f != p && p + s + f == 12 && iseven(p)
            rst = [rst; p s f]
        end
    end
    return rst
end

function printsolutions(sol::Matrix{Int})
    println("      Pol.   Fire   San.")
    println("      ----   ----   ----")
    for row in 1:size(sol, 1)
        @printf("%2i | %4i%7i%7i\n", row, sol[row, :]...)
    end
end

printsolutions(findsolution())
