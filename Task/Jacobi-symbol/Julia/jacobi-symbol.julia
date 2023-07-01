function jacobi(a, n)
    a %= n
    result = 1
    while a != 0
        while iseven(a)
            a ÷= 2
            ((n % 8) in [3, 5]) && (result *= -1)
        end
        a, n = n, a
        (a % 4 == n % 4 == 3) && (result *= -1)
        a %= n
    end
    return n == 1 ? result : 0
end

print(" Table of jacobi(a, n) for a 1 to 12, n 1 to 31\n   1   2   3   4   5   6   7   8",
    "   9  10  11  12\nn\n_____________________________________________________")
for n in 1:2:31
    print("\n", rpad(n, 3))
    for a in 1:11
        print(lpad(jacobi(a, n), 4))
    end
end
