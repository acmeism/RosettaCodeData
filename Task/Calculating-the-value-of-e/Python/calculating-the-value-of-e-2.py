e = rfct = 10 ** 1000
n = 1
while rfct:
    n += 1
    e += rfct
    rfct //= n
print(f"{e}\n...in {n} steps")
