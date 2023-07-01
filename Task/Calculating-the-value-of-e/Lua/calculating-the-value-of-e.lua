EPSILON = 1.0e-15;

fact = 1
e = 2.0
e0 = 0.0
n = 2

repeat
    e0 = e
    fact = fact * n
    n = n + 1
    e = e + 1.0 / fact
until (math.abs(e - e0) < EPSILON)

io.write(string.format("e = %.15f\n", e))
