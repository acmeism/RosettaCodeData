def bellTriangle(n):
    tri = [[0] * i for i in range(n)]
    tri[1][0] = 1
    for i in range(2, n):
        tri[i][0] = tri[i - 1][i - 2]
        for j in range(1, i):
            tri[i][j] = tri[i][j - 1] + tri[i - 1][j - 1]
    return tri

def main():
    bt = bellTriangle(51)
    print("First fifteen and fiftieth Bell numbers:")
    for i in range(1, 16):
        print("%2d: %d" % (i, bt[i][0]))
    print("50:", bt[50][0])
    print()
    print("The first ten rows of Bell's triangle:")
    for i in range(1, 11):
        print(bt[i])

main()
