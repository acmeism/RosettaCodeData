largest = 0

function iscolorful(n, base=10)
    0 <= n < 10 && return true
    dig = digits(n, base=base)
    (1 in dig || 0 in dig || !allunique(dig)) && return false
    products = Set(dig)
    for i in 2:length(dig), j in 1:length(dig)-i+1
        p = prod(dig[j:j+i-1])
        p in products && return false
        push!(products, p)
    end
    if n > largest
        global largest = n
    end
    return true
end

function testcolorfuls()
    println("Colorful numbers for 1:25, 26:50, 51:75, and 76:100:")
    for i in 1:100
        iscolorful(i) && print(rpad(i, 5))
        i % 25 == 0 && println()
    end
    csum = 0
    for i in 0:7
        j, k = i == 0 ? 0 : 10^i, 10^(i+1) - 1
        n = count(i -> iscolorful(i), j:k)
        csum += n
        println("The count of colorful numbers between $j and $k is $n.")
    end
    println("The largest possible colorful number is $largest.")
    println("The total number of colorful numbers is $csum.")
end

testcolorfuls()
