function pell(n)
    x = BigInt(floor(sqrt(n)))
    y, z, r = x, BigInt(1), x << 1
    e1, e2, f1, f2 = BigInt(1), BigInt(0), BigInt(0), BigInt(1)
    while true
        y = r * z - y
        z = div(n - y * y, z)
        r = div(x + y, z)
        e1, e2 = e2, e2 * r + e1
        f1, f2 = f2, f2 * r + f1
        a, b = f2, e2
        b, a = a, a * x + b
        if a * a - n * b * b == 1
            return a, b
        end
    end
end

for target in BigInt[61, 109, 181, 277]
    x, y = pell(target)
    println("x\u00b2 - $target", "y\u00b2 = 1 for x = $x and y = $y")
end
