function sqrt_spigot(number::Integer, places=0, limit=10000, bufsize=32)
    spigot = Channel{Char}(bufsize)

    """ Mark off pairs of digits, starting from the decimal point, working left. """
    function markoff(n)
        d = digits(n)
        pairs, len = Vector{BigInt}[], length(d)
        if isodd(len)
            push!(pairs, [pop!(d)])
            len -= 1
        end
        for i in len-1:-2:1
            push!(pairs, [d[i], d[i+1]])
        end
        places = length(pairs) - div(places , 2)
        return pairs
    end

    """ look at first digit(s) and find largest i such that i^2 < that number """
    function firststep!(pairs)
        curnum = evalpoly(BigInt(10), popfirst!(pairs))
        i = BigInt(findlast(x -> x * x <= curnum, 0:9) - 1)
        put!(spigot, Char('0' + i))
        return pairs, [i], curnum - i * i
    end

    """
    What is the largest number d that we can put in the units and also multiply times
    the divisor such that the result is still be less than or equal to what we have?
    """
    function nextstep!(pairs, founddigits, remain)
        divisor = evalpoly(BigInt(10), founddigits) * 2
        remwithnext = remain * 100 + evalpoly(BigInt(10), popfirst!(pairs))
        d = BigInt(findlast(x -> x * (divisor * 10 + x) <= remwithnext, 0:9) - 1)
        remain = remwithnext - (divisor * 10 + d) * d
        pushfirst!(founddigits, d)
        put!(spigot, Char('0' + d))
        return pairs, founddigits, remain
    end

    """ start the process of adding digits to the channel """
    function longhand_sqrt(n)
        p = markoff(n)
        if places <= 0 # 0 <= n < 1, such as 0.00144
            put!(spigot, '0')
            put!(spigot, '.')
            for i in places:1:-1
                put!(spigot, '0')
            end
        end
        pairs, founddigits, remain = firststep!(p)
        for _ in 1:limit
            if isempty(pairs) # more zeros for part right of decimal point
                push!(pairs, [0, 0], [0, 0], [0, 0], [0, 0])
            end
            (places -= 1) == 0 && put!(spigot, '.')
            pairs, founddigits, remain = nextstep!(pairs, founddigits, remain)
        end
    end

    @async(longhand_sqrt(number))

    # return the channel from which to take! digits.
    return spigot
end

function sqrt_spigot(str::String, lm=10000, bsiz=32)
    str = lowercase(str)
    if occursin("e", str)
        str, exdig = split(str, "e")
        extra = parse(Int, exdig)
        !occursin(".", str) && (str *= '.')
    else
        extra = 0
    end
    if occursin(".", str)
        if str[1] == '.'
            str = '0' * str
        elseif str[end] == str
            str = str * '0'
        end
        s1, s2 = split(str, ".")
        if extra < 0 # negative exponent, so rewrite call in non-exponential form
            pos = length(s1) + extra
            if pos < 0
                str = "0." * "0"^(-pos) * s1 * s2
            else
                str = s1[1:end-pos] * "." * s1[end-pos+1:end] * s2
            end
            return sqrt_spigot(str, lm, bsiz)
        end
        b1, b2, places = parse(BigInt, s1), parse(BigInt, s2), length(s2)
        if extra > 0
            b1 *= BigInt(10)^extra
            b2 *= BigInt(10)^extra
        end
        if isodd(places)
            n = b1 * BigInt(10)^(places + 1) + b2 * 10
            places += 1
        else
            n = b1 * BigInt(10)^places + b2
        end
        return sqrt_spigot(n, places, lm, bsiz)
    else
        return sqrt_spigot(parse(BigInt, str), 0, lm, bsiz)
    end
end

sqrt_spigot(number::Real; l=10000, b=32) = sqrt_spigot("$number", l, b)

function testspigotsqrt(arr)
    for num in arr
        spigot = sqrt_spigot(num)
        println("The square root of $num is:")
        for i in 1:500
            print(take!(spigot))
            i % 50 == 0 && println()
        end
        println()
    end
end

testspigotsqrt([2, 0.2, 0, 00.0001, 10.89, 144e-6, 2.0e4, 0.00000009, 1.44e+04, 1.44e-32])
