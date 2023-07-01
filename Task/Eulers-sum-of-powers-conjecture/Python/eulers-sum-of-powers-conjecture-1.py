def eulers_sum_of_powers():
    max_n = 250
    pow_5 = [n**5 for n in range(max_n)]
    pow5_to_n = {n**5: n for n in range(max_n)}
    for x0 in range(1, max_n):
        for x1 in range(1, x0):
            for x2 in range(1, x1):
                for x3 in range(1, x2):
                    pow_5_sum = sum(pow_5[i] for i in (x0, x1, x2, x3))
                    if pow_5_sum in pow5_to_n:
                        y = pow5_to_n[pow_5_sum]
                        return (x0, x1, x2, x3, y)

print("%i**5 + %i**5 + %i**5 + %i**5 == %i**5" % eulers_sum_of_powers())
