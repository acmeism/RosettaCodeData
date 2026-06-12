"""
    Romberg integration of function func from lower to upper
    using steps number of steps or until accuracy acc is reached.
    If acc is unspecified, will default to Float32 epsilon.
    Returns result and number of steps used.
"""
function romberg(func, lower, upper, steps, acc = (1/10)^precision(Float32, base = 10))
    h0 = upper - lower
    s0 = func(lower) + func(upper)
    r = zeros(Float64, steps + 1, steps + 1)
    r[1, 1] = s0 * h0 / 2
    n = 1

    for i in 1:steps
        if acc > 0 && i > 1 && abs(r[i, i] - r[i-1, i-1]) < acc
            return r[i, i], i
        end
        n = 2 * n
        h = h0 / n
        s = s0 / 2
        for j in 1:n-1
            s += func(lower + j * h)
        end
        f = 1
        r[i+1, 1] = s * h
        for k in 1:i
            r1 = r[i+1, k]
            r2 = r[i, k]
            f = 4 * f
            rr = (f * r1 - r2) / (f - 1)
            r[i+1, k+1] = rr
        end
    end
    return r[steps+1, steps+1], steps
end

function testromberg()
    tests = [
        (func = x -> x, label = "x constant", lower = 0, upper = 1, steps = 5, expected = 0.5, acc = 1e-8),
        (func = x -> x^2, label = "x squared", lower = 0, upper = 1, steps = 5, expected = 1 / 3, acc = 1e-8),
        (func = x -> x^3, label = "x cubed", lower = 0, upper = 1, steps = 5, expected = 1 / 4, acc = 1e-8),
        (func = x -> exp(x), label = "exp x", lower = -3, upper = 3, steps = 5, expected = exp(3) - exp(-3), acc = 1e-8),
        (func = x -> sin(x), label = "sin x", lower = 0, upper = π / 2, steps = 5, expected = 1, acc = 1e-8),
        (func = x -> cos(x), label = "cos x", lower = 0, upper = π, steps = 5, expected = 0, acc = 1e-8),
        (func = x -> 1 / x, label = "1 / x", lower = 1, upper = 100, steps = 15, expected = log(100), acc = 1e-8),
        (func = x -> 4 / (x^2 + 1), label = "4 / (x^2 + 1)", lower = 0, upper = 1, steps = 5, expected = π, acc = 1e-8),
    ]

    for (i, test) in enumerate(tests)
        result, stepstaken = romberg(test.func, test.lower, test.upper, test.steps, test.acc)
        println("Test $i: func = $(test.label), lower = $(test.lower), upper = $(test.upper), steps = $(test.steps), precision = $(test.acc)")
        println("Expected: $(test.expected), Result: $result, Error: $(abs(result - test.expected))")
        @assert abs(result - test.expected) < 1e-8 "Test $i failed"
        println("Test $i passed. Steps taken: $stepstaken\n")
    end
    println("All tests completed.")
end

testromberg()
