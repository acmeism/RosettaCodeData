size = 9
for Row in range(size):
    for Col in range(size):
        if (Row % 2 == 1 and Col % 2 == 1) or (Row % 2 == 0 and Col % 2 == 0):
            print("1", end=" ")
        else:
            print("0", end=" ")
    print()
