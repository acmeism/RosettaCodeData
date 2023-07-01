using Primes

function factorize(n)
    f = [one(n)]
    for (p, x) in factor(n)
        f = reduce(vcat, [f*p^i for i in 1:x], init=f)
    end
    f
end

function cansum(goal, list)
    if goal == 0 || list[1] == goal
         return true
    elseif length(list) > 1
        if list[1] > goal
            return cansum(goal, list[2:end])
        else
            return cansum(goal - list[1], list[2:end]) ||  cansum(goal, list[2:end])
        end
    end
    return false
end

function iszumkeller(n)
    f = reverse(factorize(n))
    fsum = sum(f)
    return iseven(fsum) && cansum(div(fsum, 2) - f[1], f[2:end])
end

function printconditionalnum(condition, maxcount, numperline = 20)
    count, spacing = 1, div(80, numperline)
    for i in 1:typemax(Int)
        if condition(i)
            count += 1
            print(rpad(i, spacing), (count - 1) % numperline == 0 ? "\n" : "")
            if count > maxcount
                return
            end
        end
    end
end

println("First 220 Zumkeller numbers:")
printconditionalnum(iszumkeller, 220)
println("\n\nFirst 40 odd Zumkeller numbers:")
printconditionalnum((n) -> isodd(n) && iszumkeller(n), 40, 8)
println("\n\nFirst 40 odd Zumkeller numbers not ending with 5:")
printconditionalnum((n) -> isodd(n) && (string(n)[end] != '5') && iszumkeller(n), 40, 8)
