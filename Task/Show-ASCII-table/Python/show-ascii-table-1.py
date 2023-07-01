for i in range(16):
    for j in range(32+i, 127+1, 16):
        if j == 32:
            k = 'Spc'
        elif j == 127:
            k = 'Del'
        else:
            k = chr(j)
        print("%3d : %-3s" % (j,k), end="")
    print()
