using Primes

factortodict(d, n) = (d[minimum(collect(keys(factor(n))))] = n)

# Numbers are from from the Perl 6 example.
numbers = [64921987050997300559,  70251412046988563035,  71774104902986066597,
           83448083465633593921,  84209429893632345702,  87001033462961102237,
           87762379890959854011,  89538854889623608177,  98421229882942378967,
           259826672618677756753, 262872058330672763871, 267440136898665274575,
           278352769033314050117, 281398154745309057242, 292057004737291582187]

mins = Dict()

Base.@sync(
    Threads.@threads for n in numbers
        factortodict(mins, n)
    end
)

answer = maximum(keys(mins))
println("The number that has the largest minimum prime factor is $(mins[answer]), with a smallest factor of $answer")
