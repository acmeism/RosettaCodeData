print5x10(a, w = 8) = for i in 0:4, j in 1:10 print(lpad(a[10i + j], w), j == 10 ? "\n" : "") end

function iscyclops(n)
    d = digits(n)
    l = length(d)
    return isodd(l) && d[l ÷ 2 + 1] == 0 && count(x -> x == 0, d) == 1
end

function isblindprimecyclops(n)
    d = digits(n)
    l = length(d)
    m = l ÷ 2 + 1
    (n == 0 || iseven(l) || d[m] != 0 || count(x -> x == 0, d) != 1) && return false
    return isprime(evalpoly(10, [d[1:m-1]; d[m+1:end]]))
end

function ispalindromicprimecyclops(n)
    d = digits(n)
    l = length(d)
    return n > 0 && isodd(l) && d[l ÷ 2 + 1] == 0 && count(x -> x == 0, d) == 1 && d == reverse(d)
end

function findcyclops(N, iscycs, nextcandidate)
    i, list = nextcandidate(-1), Int[]
    while length(list) < N
        iscycs(i) && push!(list, i)
        i = nextcandidate(i)
    end
    return list
end

function nthcyclopsfirstafter(lowerlimit, iscycs, nextcandidate)
    i, found = 0, 0
    while true
        if iscycs(i)
            found += 1
            i >= lowerlimit && break
        end
        i = nextcandidate(i)
    end
    return i, found
end

function testcyclops()
    println("The first 50 cyclops numbers are:")
    print5x10(findcyclops(50, iscyclops, x -> x + 1))
    n, c = nthcyclopsfirstafter(10000000, iscyclops, x -> x + 1)
    println("\nThe next cyclops number after 10,000,000 is $n at position $c.")

    println("\nThe first 50 prime cyclops numbers are:")
    print5x10(findcyclops(50, iscyclops, x -> nextprime(x + 1)))
    n, c = nthcyclopsfirstafter(10000000, iscyclops, x -> nextprime(x + 1))
    println("\nThe next prime cyclops number after 10,000,000 is $n at position $c.")

    println("\nThe first 50 blind prime cyclops numbers are:")
    print5x10(findcyclops(50, isblindprimecyclops, x -> nextprime(x + 1)))
    n, c = nthcyclopsfirstafter(10000000, isblindprimecyclops, x -> nextprime(x + 1))
    println("\nThe next prime cyclops number after 10,000,000 is $n at position $c.")

    println("\nThe first 50 palindromic prime cyclops numbers are:")
    print5x10(findcyclops(50, ispalindromicprimecyclops, x -> nextprime(x + 1)))
    n, c = nthcyclopsfirstafter(10000000, ispalindromicprimecyclops, x -> nextprime(x + 1))
    println("\nThe next prime cyclops number after 10,000,000 is $n at position $c.")
end

testcyclops()
