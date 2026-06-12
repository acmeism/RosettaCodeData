#!/usr/bin/env python3

def display(matrix):
    for row in matrix:
        print(' '.join(f" {element}" if element > 0 else f"{element}" for element in row))
    print()

def sign_change_count(row):
    sign_changes = 0
    for i in range(1, len(row)):
        if row[i - 1] == -row[i]:
            sign_changes += 1
    return sign_changes

def walsh_matrix(size):
    walsh = [[0 for _ in range(size)] for _ in range(size)]
    walsh[0][0] = 1

    k = 1
    while k < size:
        for i in range(k):
            for j in range(k):
                walsh[i + k][j] = walsh[i][j]
                walsh[i][j + k] = walsh[i][j]
                walsh[i + k][j + k] = -walsh[i][j]
        k += k
    return walsh

def main():
    for order in [2, 4, 5]:
        size = 1 << order
        for order_type in ["Natural", "Sequency"]:
            print(f"Walsh matrix of order {order}, {order_type} order:")
            walsh = walsh_matrix(size)
            if order_type == "Sequency":
                walsh.sort(key=sign_change_count)
            display(walsh)

if __name__ == "__main__":
    main()
