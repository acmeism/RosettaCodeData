""" https://rosettacode.org/wiki/Prime_numbers_of_measurement """

using DelimitedFiles

const NMAX = 3200

function primes_of_measurement()
    a = collect(1:NMAX)
    for piv in 2:lastindex(a)-1
        for i in 1:piv-1
            i >= lastindex(a) && break
            su = a[i] + a[i+1]
            filter!(!=(su), a)
            for j in i+2:piv
                j > lastindex(a) && break
                su += a[j]
                filter!(!=(su), a)
                su > NMAX && break
            end
        end
    end
    println("First hundred:")
    display(reshape(a[1:100], 10, 10)')
    println("\nOne thousandth: ", a[1000])
end

primes_of_measurement()
