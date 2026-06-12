using Primes

function firstlastprimeprod(number_wanted)
    for num in 1:number_wanted
        fac = collect(factor(num))
        product = isempty(fac) ? 1 : fac[begin][begin] * fac[end][begin]
        print(rpad(product, 6), num % 10 == 0 ? "\n" : "")
    end
end

firstlastprimeprod(100)
