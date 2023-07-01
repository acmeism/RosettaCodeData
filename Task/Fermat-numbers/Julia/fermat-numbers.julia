using Primes

fermat(n) = BigInt(2)^(BigInt(2)^n) + 1
prettyprint(fdict) = replace(replace(string(fdict), r".+\(([^)]+)\)" => s"\1"), r"\=\>" => "^")

function factorfermats(max, nofactor=false)
    for n in 0:max
        fm = fermat(n)
        if nofactor
            println("Fermat number F($n) is $fm.")
            continue
        end
        factors = factor(fm)
        println("Fermat number F($n), $fm, ",
            length(factors) < 2 ? "is prime." : "factors to $(prettyprint(factors)).")
    end
end

factorfermats(9, true)
factorfermats(10)
