""" Convert numeric string in base 10 to base 2 floating point string """
function dec2bin(x::String)
    bx = parse(BigFloat, x)
    xneg = bx >= 0 ? false : true
    bx = BigFloat(xneg ? -bx : bx)
    pre, post, n = "", "", div(nextpow(2, bx), 2)
    while bx > 0
        a, bx = divrem(bx, BigFloat(n))
        if n >= 1
            pre *= a > 0 ? '1' : '0'
        else
            post *= a > 0 ? '1' : '0'
        end
        n /= 2.0
    end
    (xneg ? "-" : "") * pre * "." * post
end

""" Convert binary floating point format string to Float64 numeric type """
function bin2dec(binfloat::String)
    binfloat = strip(binfloat)
    if binfloat[1] == '-'
        binfloat = binfloat[2:end]
        xneg = -1
    else
        xneg = 1
    end
    if occursin(".", binfloat)
        (pre, post) = split(binfloat, ".")
        mult = BigInt(2)^length(post)
        return xneg * (BigFloat(parse(BigInt, pre, base=2)) +
            BigFloat(parse(BigInt, post, base=2) / mult))
    else
        return xneg * BigFloat(parse(BigInt, binfloat, base=2))
    end
end

function testconversions(tdata)
    println("String (base 10)    Base 2     Base 10")
    for dstring in testdata
        b2 = dec2bin(dstring)
        b10 = bin2dec(b2)
        println(lpad(dstring, 10), lpad(b2, 18), lpad(b10, 10))
    end
end

testdata = ["23.34375", "11.90625", "-23.34375", "-11.90625"]
testconversions(testdata)
