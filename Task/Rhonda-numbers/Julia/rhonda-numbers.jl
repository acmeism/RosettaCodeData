using Primes

isRhonda(n, b) = prod(digits(n, base=b)) == b * sum([prod(pair) for pair in factor(n).pe])

function displayrhondas(low, high, nshow)
    for b in filter(!isprime, low:high)
        n, rhondas = 1, Int[]
        while length(rhondas) < nshow
            isRhonda(n, b) && push!(rhondas, n)
            n += 1
        end
        println("First $nshow Rhondas in base $b:")
        println("In base 10: ", rhondas)
        println("In base $b: ", replace(string([string(i, base=b) for i in rhondas]), "\"" => ""), "\n")
    end
end

displayrhondas(2, 16, 15)
