function approxEquals(value, other, epsilon)
    return math.abs(value - other) < epsilon
end

function test(a, b)
    local epsilon = 1e-18
    print(string.format("%f, %f => %s", a, b, tostring(approxEquals(a, b, epsilon))))
end

function main()
    test(100000000000000.01, 100000000000000.011);
    test(100.01, 100.011)
    test(10000000000000.001 / 10000.0, 1000000000.0000001000)
    test(0.001, 0.0010000001)
    test(0.000000000000000000000101, 0.0)
    test(math.sqrt(2.0) * math.sqrt(2.0), 2.0)
    test(-math.sqrt(2.0) * math.sqrt(2.0), -2.0)
    test(3.14159265358979323846, 3.14159265358979324)
end

main()
