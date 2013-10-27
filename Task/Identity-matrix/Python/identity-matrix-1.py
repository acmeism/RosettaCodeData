def identity(size):
    matrix = [[0]*size for i in range(size)]
    #matrix = [[0] * size] * size    #Has a flaw. See http://stackoverflow.com/questions/240178/unexpected-feature-in-a-python-list-of-lists

    for i in range(size):
        matrix[i][i] = 1

    for rows in matrix:
        for elements in rows:
            print elements,
        print ""
