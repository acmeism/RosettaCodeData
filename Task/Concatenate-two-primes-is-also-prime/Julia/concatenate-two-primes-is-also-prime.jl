using Primes

function catprimes()
    found, pri = Int[], primes(100)
    for x in pri, y in pri
        n = x + y * (x < 10 ? 10 : 100)
        isprime(n) && push!(found, n)
    end
    return sort!(unique(found))
end

foreach(p -> print(lpad(last(p), 5), first(p) % 16 == 0 ? "\n" : ""),
    catprimes() |> enumerate)
