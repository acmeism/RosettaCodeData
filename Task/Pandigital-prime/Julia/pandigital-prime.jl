using Primes

function pandigitals(firstdig, lastdig)
    mask = primesmask(10^(lastdig - firstdig + 1))
    for j in lastdig:-1:firstdig
        n = j - firstdig + 1
        for i in evalpoly(10, firstdig:j):-1:evalpoly(10, j:-1:firstdig)
            if mask[i]
                d = digits(i)
                if length(d) == n && all(x -> count(y -> y == x, d) == 1, firstdig:j)
                    return i
                end
            end
        end
    end
    return 0
end

for firstdigit in [1, 0]
    println("Max pandigital prime over [$firstdigit, 9] is ", pandigitals(firstdigit, 9))
end
