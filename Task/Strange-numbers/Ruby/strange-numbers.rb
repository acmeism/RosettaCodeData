def digits(n)
    result = []
    while n > 0
        rem = n % 10
        result.unshift(rem)
        n = n / 10
    end
    return result
end

def isStrange(n)
    def test(a, b)
        abs = (a - b).abs
        return abs == 2 || abs == 3 || abs == 5 || abs == 7
    end

    xs = digits(n)
    for i in 1 .. xs.length - 1
        if !test(xs[i - 1], xs[i]) then
            return false
        end
    end
    return true
end

xs = []
for i in 100 .. 500
    if isStrange(i) then
        xs << i
    end
end

print "Strange numbers in range [100 .. 500]\n"
print "(Total: %d)\n\n" % [xs.length]

xs.each_slice(10) do |s|
    print s, "\n"
end
