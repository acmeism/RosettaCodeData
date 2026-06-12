using Primes

""" Print the series of iccanobif prime numbers up to wanted """
function iccanobifs(wanted)
    digbuf = zeros(Int, 11000)
    fib, prev, prevprev, fcount = big"0", big"1", big"0", 0
    println("First $wanted Iccanobif primes:")
    while fcount < wanted
        fib = prev + prevprev
        prevprev = prev
        prev = fib
        digits!(digbuf, fib)
        candidate = evalpoly(big"10", reverse(digbuf[begin:findlast(!iszero, digbuf)]))
        if isprime(candidate)
            fcount += 1
            dlen = ndigits(candidate)
            if dlen < 90
                println(candidate, " ($dlen digit$(dlen == 1 ? "" : "s"))")
            else
                s = string(candidate)
                println(s[1:30], " ... ", s[end-29:end], " ($dlen digits)")
            end
        end
    end
end

iccanobifs(30)
