$p = [
    false, false, true, true, false,
    true, false, true, false, false,
    false, true, false, true, false,
    false, false, true, false
]

def isStrange(n)
    if n < 10 then
        return false
    end

    while n >= 10 do
        if not $p[n % 10 + (n / 10).floor % 10] then
            return false
        end
        n = (n / 10).floor
    end

    return true
end

def test(nMin, nMax)
    k = 0
    for n in nMin .. nMax
        if isStrange(n) then
            print n
            k = k + 1
            if k % 10 != 0 then
                print ' '
            else
                print "\n"
            end
        end
    end
end

test(101, 499)
