using Primes

""" An undulating number is an integer which has the digit form ABABAB... """
struct UndulatingInteger
    ubase::Int
    min_digits::Int
end

""" Iterate undulating numbers """
function Base.iterate(u::UndulatingInteger, state = (1, 0, u.min_digits))
    a, b, n = state
    i = foldl((i, j) -> u.ubase * i + (iseven(j) ? b : a), 1:n, init = 0)
    b += 1
    if b == a
        b += 1
    end
    if b >= u.ubase
        b = 0
        a += 1
        if a >= u.ubase
            a = 1
            n += 1
        end
    end
    return i, (a, b, n)
end

""" Run tests on the sequence in a given base `ubase` """
function test_undulating(ubase)
    println("Three digit undulating numbers in base $ubase:")
    for (i, n) in enumerate(UndulatingInteger(ubase, 3))
        n >= ubase^3 - 1 && break
        print(lpad(n, 5), i % 9 == 0 ? "\n" : " ")
    end
    println("\nFour digit undulating numbers in base $ubase:")
    for (i, n) in enumerate(UndulatingInteger(ubase, 4))
        n >= ubase^4 - 1 && break
        print(lpad(n, 5), i % 9 == 0 ? "\n" : " ")
    end
    println("\nThree digit undulating numbers in base $ubase which are primes:")
    for (i, n) in enumerate(Iterators.filter(isprime, UndulatingInteger(ubase, 3)))
        n >= ubase^3 - 1 && break
        print(n, i % 20 == 0 ? "\n" : " ")
    end

    lastn = 0
    for (i, n) in enumerate(UndulatingInteger(ubase, 3))
        if i == 600
            print("\n\nThe 600th undulating number in base $ubase is $n.")
        elseif n > 2^53
            print("\n\nNumber of undulating numbers in base $ubase less than 2^53 is ",
               i - 1, "\n   with the largest such number $lastn.\n\n")
            break
        end
        lastn = n
    end
end

test_undulating(10)
test_undulating(7)
