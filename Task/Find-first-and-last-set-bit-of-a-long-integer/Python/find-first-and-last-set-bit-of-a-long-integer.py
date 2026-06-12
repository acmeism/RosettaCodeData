def msb(x):
    return x.bit_length() - 1

def lsb(x):
    return msb(x & -x)

for i in range(6):
    x = 42 ** i
    print("%10d MSB: %2d LSB: %2d" % (x, msb(x), lsb(x)))

for i in range(6):
    x = 1302 ** i
    print("%20d MSB: %2d LSB: %2d" % (x, msb(x), lsb(x)))
