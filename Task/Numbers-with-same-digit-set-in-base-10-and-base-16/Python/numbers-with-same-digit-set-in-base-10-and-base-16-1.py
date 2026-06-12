col = 0
for i in range(100000):
    if set(str(i)) == set(hex(i)[2:]):
        col += 1
        print("{:7}".format(i), end='\n'[:col % 10 == 0])
print()
