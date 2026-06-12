on isPrime(n)
    if (n < 4) then return (n > 1)
    if ((n mod 2 is 0) or (n mod 3 is 0)) then return false
    repeat with i from 5 to (n ^ 0.5) div 1 by 6
        if ((n mod i is 0) or (n mod (i + 2) is 0)) then return false
    end repeat

    return true
end isPrime

-- primes list created from scratch.
on sortPrimesFromList:givenList
    return my sortPrimesFromList:givenList toList:{}
end sortPrimesFromList:

-- primes list supplied as a parameter, its current contents assumed to be already ordered ascending.
on sortPrimesFromList:givenList toList:primes
    set j to (count primes)
    repeat with this in givenList
        set this to this's contents
        if (isPrime(this)) then
            set end of primes to this
            set j to j + 1
            if (j > 1) then
                repeat with i from (j - 1) to 1 by -1
                    set v to primes's item i
                    if (v > this) then
                        set primes's item (i + 1) to v
                    else
                        set i to i + 1
                        exit repeat
                    end if
                end repeat
                set primes's item i to this
            end if
        end if
    end repeat

    return primes
end sortPrimesFromList:toList:

on demo()
    set primes to my sortPrimesFromList:{2, 43, 81, 22, 63, 13, 7, 95, 103}
    log primes
    my sortPrimesFromList:{8, 137, 19, 5, 44, 23} toList:primes
    log primes
end demo

demo()
