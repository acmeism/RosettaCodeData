using Primes

isAchilles(n) = (p = [x[2] for x in factor(n).pe]; all(>(1), p) && gcd(p) == 1)

isstrongAchilles(n) = isAchilles(n) && isAchilles(totient(n))

function teststrongachilles(nachilles = 50, nstrongachilles = 100)
    # task 1
    println("First $nachilles Achilles numbers:")
    n, found = 0, 0
    while found < nachilles
        if isAchilles(n)
            found += 1
            print(rpad(n, 5), found % 10 == 0 ? "\n" : "")
        end
        n += 1
    end
    # task 2
    println("\nFirst $nstrongachilles strong Achilles numbers:")
    n, found = 0, 0
    while found < nstrongachilles
        if isstrongAchilles(n)
            found += 1
            print(rpad(n, 7), found % 10 == 0 ? "\n" : "")
        end
        n += 1
    end
    # task 3
    println("\nCount of Achilles numbers for various intervals:")
    intervals = [10:99, 100:999, 1000:9999, 10000:99999, 100000:999999]
    for interval in intervals
        println(lpad(interval, 15), " ", count(isAchilles, interval))
    end
end

teststrongachilles()
