using Lazy

function rises_and_falls(n)
    if n < 10
        return 0, 0
    end
    lastr, rises, falls = n % 10, 0, 0
    while n != 0
        n, r = divrem(n, 10)
        if r > lastr
            falls += 1
        elseif r < lastr
            rises += 1
        end
        lastr = r
    end
    return rises, falls
end

isA296712(x) = ((a, b) = rises_and_falls(x); return a == b)

function genA296712(N, M)
    A296712 = filter(isA296712, Lazy.range(1));
    j = 0
    for i in take(200, A296712)
        j += 1
        print(lpad(i, 4), j % 20 == 0 ? "\n" : "")
    end
    for i in take(M, A296712)
        j = i
    end
    println("\nThe $M-th number in sequence A296712 is $j.")
end

genA296712(200, 10_000_000)
