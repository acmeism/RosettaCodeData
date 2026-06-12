range17 = range(17)
a = [['0'] * 17 for i in range17]
idx = [0] * 4


def find_group(mark, min_n, max_n, depth=1):
    if (depth == 4):
        prefix = "" if (mark == '1') else "un"
        print("Fail, found totally {}connected group:".format(prefix))
        for i in range(4):
            print(idx[i])
        return True

    for i in range(min_n, max_n):
        n = 0
        while (n < depth):
            if (a[idx[n]][i] != mark):
                break
            n += 1

        if (n == depth):
            idx[n] = i
            if (find_group(mark, 1, max_n, depth + 1)):
                return True

    return False


if __name__ == '__main__':
    for i in range17:
        a[i][i] = '-'
    for k in range(4):
        for i in range17:
            j = (i + pow(2, k)) % 17
            a[i][j] = a[j][i] = '1'

    # testcase breakage
    # a[2][1] = a[1][2] = '0'

    for row in a:
        print(' '.join(row))

    for i in range17:
        idx[0] = i
        if (find_group('1', i + 1, 17) or find_group('0', i + 1, 17)):
            print("no good")
            exit()

    print("all good")
