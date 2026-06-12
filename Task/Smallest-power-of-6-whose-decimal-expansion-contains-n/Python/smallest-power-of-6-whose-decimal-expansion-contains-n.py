def smallest_six(n):
    p = 1
    while str(n) not in str(p): p *= 6
    return p

for n in range(22):
    print("{:2}: {}".format(n, smallest_six(n)))
