# Formatting output as in Go example.
using Primes, Formatting

isncubedplus2prime(x) = begin fx = x * x * x + 2; (isprime(fx), fx) end

tostring(x, fx) = "n = " * lpad(x, 3) * " => n³ + 2 =" * lpad(format(fx, commas=true), 10)

function filterprintresults(x_to_bool_and_fx, start, stop, stringify=(x, fx)->"$x $fx", doprint=true)
    ncount = 0
    println("Filtering $x_to_bool_and_fx for integers between $start and $stop:\n")
    for n in start+1:stop-1
        isone, result = x_to_bool_and_fx(n)
        if isone
            doprint && println(stringify(n, result))
            ncount += 1
        end
    end
    println("\nThe total found was $ncount.")
end

filterprintresults(isncubedplus2prime, 0, 200, tostring)
