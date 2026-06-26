def prime(a):
    return not (a < 2 or any(a % x == 0 for x in range(2, int(a**0.5) + 1)))
