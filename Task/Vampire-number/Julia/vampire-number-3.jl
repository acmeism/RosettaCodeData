const TENS = [UInt(10)^i for i in 0:19]

function dtally(x::UInt)
    t = UInt(0)
    while x > 0
        t += UInt(1) << ((x % 10) * 6)
        x ÷= 10
    end
    return t
end

function fangs(x::UInt)
    f = UInt[]
    nd = ndigits(x)
    nd & 1 != 0 && return f
    nd ÷= 2

    lo = max(TENS[nd], (x + TENS[nd+1] - 2) ÷ (TENS[nd+1] - 1))
    hi = min(x ÷ lo, floor(UInt, sqrt(x)))

    t = dtally(x)
    for a in lo:hi
        b = x ÷ a
        if a * b == x && ((a % 10) != 0 || (b % 10) != 0) && t == dtally(a) + dtally(b)
            push!(f, a)
        end
    end

    return f
end

function show_fangs(x::UInt, f::Vector{UInt})
    print(x)
    for fang in f
        print(" = ", fang, " x ", x ÷ fang)
    end
    println()
end

function testfangs()
    bigs = UInt[16758243290880, 24959017348650, 14593825548650]

    # Find first 25 vampire numbers
    x = UInt(1)
    n = 0
    while n < 25
        f = fangs(x)
        if !isempty(f)
            n += 1
            print(lpad(n, 2), ": ")
            show_fangs(x, f)
        end
        x += 1
    end

    println()

    # Check big numbers
    for b in bigs
        f = fangs(b)
        if !isempty(f)
            show_fangs(b, f)
        else
            println(b, " is not vampiric")
        end
    end
end

testfangs()
