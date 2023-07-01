from pprint import pprint as pp

def pascal_upp(n):
    s = [[0] * n for _ in range(n)]
    s[0] = [1] * n
    for i in range(1, n):
        for j in range(i, n):
            s[i][j] = s[i-1][j-1] + s[i][j-1]
    return s

def pascal_low(n):
    # transpose of pascal_upp(n)
    return [list(x) for x in zip(*pascal_upp(n))]

def pascal_sym(n):
    s = [[1] * n for _ in range(n)]
    for i in range(1, n):
        for j in range(1, n):
            s[i][j] = s[i-1][j] + s[i][j-1]
    return s


if __name__ == "__main__":
    n = 5
    print("\nUpper:")
    pp(pascal_upp(n))
    print("\nLower:")
    pp(pascal_low(n))
    print("\nSymmetric:")
    pp(pascal_sym(n))
