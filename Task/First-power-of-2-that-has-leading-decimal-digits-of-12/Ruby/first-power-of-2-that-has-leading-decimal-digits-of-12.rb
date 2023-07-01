def p(l, n)
    test = 0
    logv = Math.log(2.0) / Math.log(10.0)
    factor = 1
    loopv = l
    while loopv > 10 do
        factor = factor * 10
        loopv = loopv / 10
    end
    while n > 0 do
        test = test + 1
        val = (factor * (10.0 ** ((test * logv).modulo(1.0)))).floor
        if val == l then
            n = n - 1
        end
    end
    return test
end

def runTest(l, n)
    print "P(%d, %d) = %d\n" % [l, n, p(l, n)]
end

runTest(12, 1)
runTest(12, 2)
runTest(123, 45)
runTest(123, 12345)
runTest(123, 678910)
