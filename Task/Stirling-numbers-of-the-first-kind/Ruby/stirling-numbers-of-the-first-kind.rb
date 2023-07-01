$cache = {}
def sterling1(n, k)
    if n == 0 and k == 0 then
        return 1
    end
    if n > 0 and k == 0 then
        return 0
    end
    if k > n then
        return 0
    end
    key = [n, k]
    if $cache[key] then
        return $cache[key]
    end
    value = sterling1(n - 1, k - 1) + (n - 1) * sterling1(n - 1, k)
    $cache[key] = value
    return value
end

MAX = 12
def main
    print "Unsigned Stirling numbers of the first kind:\n"
    print "n/k"
    for n in 0 .. MAX
        print "%10d" % [n]
    end
    print "\n"

    for n in 0 .. MAX
        print "%-3d" % [n]
        for k in 0 .. n
            print "%10d" % [sterling1(n, k)]
        end
        print "\n"
    end

    print "The maximum value of S1(100, k) =\n"
    previous = 0
    for k in 1 .. 100
        current = sterling1(100, k)
        if previous < current then
            previous = current
        else
            print previous, "\n"
            print "(%d digits, k = %d)\n" % [previous.to_s.length, k - 1]
            break
        end
    end
end

main()
