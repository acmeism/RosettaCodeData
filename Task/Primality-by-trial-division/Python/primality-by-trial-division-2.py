def prime2(a):
    if a == 2: return True
    if a < 2 or a % 2 == 0: return False
    return not any(a % x == 0 for x in range(3, int(a**0.5) + 1, 2))
