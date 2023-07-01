#!/usr/bin/env python3

# Sample 1
a1 = [[1, 2], [3, 4]]
b1 = [[0, 5], [6, 7]]

# Sample 2
a2 = [[0, 1, 0], [1, 1, 1], [0, 1, 0]]
b2 = [[1, 1, 1, 1], [1, 0, 0, 1], [1, 1, 1, 1]]

def kronecker(matrix1, matrix2):
    final_list = []
    sub_list = []

    count = len(matrix2)

    for elem1 in matrix1:
        counter = 0
        check = 0
        while check < count:
            for num1 in elem1:
                for num2 in matrix2[counter]:
                    sub_list.append(num1 * num2)
            counter += 1
            final_list.append(sub_list)
            sub_list = []
            check +=1

    return final_list

# Result 1
result1 = kronecker(a1, b1)
for elem in result1:
    print(elem)

print("")

# Result 2
result2 = kronecker(a2, b2)
for elem in result2:
    print(elem)
