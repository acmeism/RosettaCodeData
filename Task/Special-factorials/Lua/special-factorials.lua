-- n! = 1 * 2 * 3 * ... * n-1 * n
function factorial(n)
    local result = 1
    local i = 1
    while i <= n do
        result = result * i
        i = i + 1
    end
    return result
end

-- if(n!) = n
function inverse_factorial(f)
    local p = 1
    local i = 1

    if f == 1 then
        return 0
    end

    while p < f do
        p = p * i
        i = i + 1
    end

    if p == f then
        return i - 1
    end
    return -1
end

-- sf(n) = 1! * 2! * 3! * ... * (n-1)! * n!
function super_factorial(n)
    local result = 1
    local i = 1
    while i <= n do
        result = result * factorial(i)
        i = i + 1
    end
    return result
end

-- H(n) = 1^1 * 2^2 * 3^3 * ... * (n-1)^(n-1) * n^n
function hyper_factorial(n)
    local result = 1
    for i=1, n do
        result = result * i ^ i
    end
    return result
end

-- af(n) = -1^(n-1)*1! + -1^(n-1)*2! + ... + -1^(1)*(n-1)! + -1^(0)*n!
function alternating_factorial(n)
    local result = 0
    for i=1, n do
        if (n - i) % 2 == 0 then
            result = result + factorial(i)
        else
            result = result - factorial(i)
        end
    end
    return result
end

-- n$ = n ^ (n-1) ^ ... ^ 2 ^ 1
function exponential_factorial(n)
    local result = 0
    for i=1, n do
        result = i ^ result
    end
    return result
end

function test_factorial(count, f, name)
    print("First " .. count .. " " .. name)
    for i=1,count do
        io.write(math.floor(f(i - 1)) .. "  ")
    end
    print()
    print()
end

function test_inverse(f)
    local n = inverse_factorial(f)
    if n < 0 then
        print("rf(" .. f .. " = No Solution")
    else
        print("rf(" .. f .. " = " .. n)
    end
end

test_factorial(9, super_factorial, "super factorials")
test_factorial(8, hyper_factorial, "hyper factorials")
test_factorial(10, alternating_factorial, "alternating factorials")
test_factorial(5, exponential_factorial, "exponential factorials")

test_inverse(1)
test_inverse(2)
test_inverse(6)
test_inverse(24)
test_inverse(120)
test_inverse(720)
test_inverse(5040)
test_inverse(40320)
test_inverse(362880)
test_inverse(3628800)
test_inverse(119)
