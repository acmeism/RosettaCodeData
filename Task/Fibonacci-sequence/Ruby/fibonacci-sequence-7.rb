def fib_gen
    a, b = 1, 1
    lambda {ret, a, b = a, b, a+b; ret}
end
