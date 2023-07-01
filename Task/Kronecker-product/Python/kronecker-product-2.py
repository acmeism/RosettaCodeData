# Sample 1
r = [[1, 2], [3, 4]]
s = [[0, 5], [6, 7]]

# Sample 2
t = [[0, 1, 0], [1, 1, 1], [0, 1, 0]]
u = [[1, 1, 1, 1], [1, 0, 0, 1], [1, 1, 1, 1]]

def kronecker(matrix1, matrix2):
    return [[num1 * num2 for num1 in elem1 for num2 in matrix2[row]] for elem1 in matrix1 for row in range(len(matrix2))]

# Result 1:
for row in kronecker(r, s):
    print(row)
print()

# Result 2
for row in kronecker(t, u):
    print(row)
