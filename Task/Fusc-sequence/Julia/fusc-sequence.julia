using Memoize, Formatting

@memoize function sternbrocot(n)
    if n < 2
        return n
    elseif iseven(n)
        return sternbrocot(div(n, 2))
    else
        m = div(n - 1, 2)
        return sternbrocot(m) + sternbrocot(m + 1)
    end
end

function fusclengths(N=100000000)
    println("sequence number : fusc value")
    maxlen = 0
    for i in 0:N
        x = sternbrocot(i)
        if (len = length(string(x))) > maxlen
            println(lpad(format(i, commas=true), 15), " : ", format(x, commas=true))
            maxlen = len
        end
    end
end

println("The first 61 fusc numbers are: ", [sternbrocot(x) for x in 0:60])
fusclengths()
