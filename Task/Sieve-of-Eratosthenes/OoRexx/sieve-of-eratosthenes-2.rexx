/*ooRexx program generates primes via sieve of Eratosthenes algorithm.
*                       wheel version, 2 handled as special case
*                       loops optimized: outer loop stops at the square root of
*                         the limit, inner loop starts at the square of the
*                         prime just found
*                       use a list rather than an array and remove composites
*                         rather than just mark them
*                       convert list of primes to a list of output messages and
*                         display them with one say statement
*******************************************************************************/
    arg highest                             -- get highest number to use.
    if \highest~datatype('W') then
        highest = 200                       -- use default value.
    w = highest~length                      -- width of the biggest number,
                                            --  it's used for aligned output.
    thePrimes = .list~of(2)                 -- the first prime is 2.
    loop j = 3 to highest by 2              -- populate the list with odd nums.
        thePrimes~append(j)
    end

    j = 3                                   -- first prime (other than 2)
    ix = thePrimes~index(j)                 -- get the index of 3 in the list.
    loop while j*j <= highest               -- strike multiples of odd ints.
                                            --  up to sqrt(highest).
        loop jm = j*j to highest by j+j     -- start at J squared, incr. by 2*J.
            thePrimes~removeItem(jm)        -- delete it since it's composite.
        end
        ix = thePrimes~next(ix)             -- the index of the next prime.
        j = thePrimes[ix]                   -- the next prime.
    end
    np = thePrimes~items                    -- the number of primes since the
                                            --  list is now only primes.
    out1 = '           prime number'        -- first part of output messages.
    out2 = ' --> '                          -- middle part of output messages.
    ix = thePrimes~first
    loop n = 1 to np                        -- change the list of primes
                                            --  to output messages.
        thePrimes[ix] = out1 n~right(w) out2 thePrimes[ix]~right(w)
        ix = thePrimes~next(ix)
    end
    last = np~right(out1~length+1+w) 'primes found up to and including ' highest
    thePrimes~append(.endofline || last)    -- add blank line and summary line.
    say thePrimes~makearray~toString        -- display the output.
    exit
