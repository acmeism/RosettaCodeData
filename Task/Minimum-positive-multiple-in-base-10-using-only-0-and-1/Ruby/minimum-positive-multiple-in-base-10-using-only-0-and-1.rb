def mod(m, n)
    result = m % n
    if result < 0 then
        result = result + n
    end
    return result
end

def getA004290(n)
    if n == 1 then
        return 1
    end
    arr = Array.new(n) { Array.new(n, 0) }
    arr[0][0] = 1
    arr[0][1] = 1
    m = 0
    while true
        m = m + 1
        if arr[m - 1][mod(-10 ** m, n)] == 1 then
            break
        end
        arr[m][0] = 1
        for k in 1 .. n - 1
            arr[m][k] = [arr[m - 1][k], arr[m - 1][mod(k - 10 ** m, n)]].max
        end
    end
    r = 10 ** m
    k = mod(-r, n)
    (m - 1).downto(1) { |j|
        if arr[j - 1][k] == 0 then
            r = r + 10 ** j
            k = mod(k - 10 ** j, n)
        end
    }
    if k == 1 then
        r = r + 1
    end
    return r
end

testCases = Array(1 .. 10)
testCases.concat(Array(95 .. 105))
testCases.concat([297, 576, 594, 891, 909, 999, 1998, 2079, 2251, 2277, 2439, 2997, 4878])
for n in testCases
    result = getA004290(n)
    print "A004290(%d) = %d = %d * %d\n" % [n, result, n, result / n]
end
