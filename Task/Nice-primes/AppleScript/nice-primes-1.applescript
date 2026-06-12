on sieveOfEratosthenes(limit)
    script o
        property numberList : {missing value}
    end script

    repeat with n from 2 to limit
        set end of o's numberList to n
    end repeat
    repeat with n from 2 to (limit ^ 0.5 div 1)
        if (item n of o's numberList is n) then
            repeat with multiple from (n * n) to limit by n
                set item multiple of o's numberList to missing value
            end repeat
        end if
    end repeat

    return o's numberList's numbers
end sieveOfEratosthenes

on nicePrimes(a, b)
    script o
        property primes : reverse of sieveOfEratosthenes(b)
        property niceOnes : {}
    end script

    repeat with n in o's primes
        set n to n's contents
        if (n < a) then exit repeat
        set sumn to (n - 1) mod 9 + 1
        -- n being a prime, sumn can obviously never be 0 here. Tests suggest that it's never 6 or 9
        -- either and that it's only ever 3 when n is 3. Occurrences of the other single-digit
        -- possibilities are fairly evenly distributed. Testing for a prime result — 2, 5, 7, or the
        -- very unlikely 3 — requires one to four tests, depending on which test eventually decides
        -- the matter. An alternative is to eliminate 8, 4, and 1 instead, which can be done with
        -- only one or two tests. The test eliminating both 8 and 4 should be tried first.
        if ((sumn mod 4 > 0) and (sumn > 1)) then set end of o's niceOnes to n
    end repeat

    return reverse of o's niceOnes
end nicePrimes

return nicePrimes(501, 999)
