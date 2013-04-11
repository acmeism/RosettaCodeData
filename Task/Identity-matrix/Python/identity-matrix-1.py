def identity(size):
    matrix = [[0] * size] * size

    for i in range(size):
        matrix[i][i] = 1

    for rows in matrix:
        for elements in rows:
            print elements,
        print ""
