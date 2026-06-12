using Primes

function containstringinbase(N, str, base, verbose = true)
    arr = filter(n -> occursin(str, string(n, base=base)), primes(N))
    println("\n\nFound $(length(arr)) primes < $N which contain the string $str in base $base representation.")
    verbose && foreach(p -> print(rpad(p[2], 6), p[1] % 12 == 0 ? "\n" : ""), enumerate(arr))
end

containstringinbase(100_000, "123", 10)
containstringinbase(1_000_000, "123", 10, false)
containstringinbase(1_000_000_000, "123", 10, false)
