using Primes

function cubanprimes(N)
    cubans = zeros(Int, N)
    cube100k, cube1, count = 0, 1, 1
    for i in Iterators.countfrom(1)
        j = BigInt(i + 1)
        cube2 = j^3
        diff = cube2 - cube1
        if isprime(diff)
            count ≤ N && (cubans[count] = diff)
            if count == 100000
                cube100k = diff
                break
            end
            count += 1
        end
        cube1 = cube2
    end
    println("The first $N cuban primes are: ")
    foreach(x -> print(lpad(cubans[x] == 0 ? "" : cubans[x], 10), x % 8 == 0 ? "\n" : ""), 1:N)
    println("\nThe 100,000th cuban prime is ", cube100k)
end

cubanprimes(200)
