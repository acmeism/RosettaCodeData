size = 9
for row in range(size):
    for col in range(size):
        if row == 0 or row == size-1 or col == 0 or col == size-1:
            print("1", end=" ")
        else:
            print("0", end=" ")
    print()
