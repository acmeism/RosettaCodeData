def indexOf(haystack, needle):
    idx = 0
    for straw in haystack:
        if straw == needle:
            return idx
        else:
            idx += 1
    return -1

def getDigits(n, le, digits):
    while n > 0:
        r = n % 10
        if r == 0 or indexOf(digits, r) >= 0:
            return False
        le -= 1
        digits[le] = r
        n = int(n / 10)
    return True

def removeDigit(digits, le, idx):
    pows = [1, 10, 100, 1000, 10000]
    sum = 0
    pow = pows[le - 2]
    i = 0
    while i < le:
        if i == idx:
            i += 1
            continue
        sum = sum + digits[i] * pow
        pow = int(pow / 10)
        i += 1
    return sum

def main():
    lims = [ [ 12, 97 ], [ 123, 986 ], [ 1234, 9875 ], [ 12345, 98764 ] ]
    count = [0 for i in range(5)]
    omitted = [[0 for i in range(10)] for j in range(5)]

    i = 0
    while i < len(lims):
        n = lims[i][0]
        while n < lims[i][1]:
            nDigits = [0 for k in range(i + 2)]
            nOk = getDigits(n, i + 2, nDigits)
            if not nOk:
                n += 1
                continue
            d = n + 1
            while d <= lims[i][1] + 1:
                dDigits = [0 for k in range(i + 2)]
                dOk = getDigits(d, i + 2, dDigits)
                if not dOk:
                    d += 1
                    continue
                nix = 0
                while nix < len(nDigits):
                    digit = nDigits[nix]
                    dix = indexOf(dDigits, digit)
                    if dix >= 0:
                        rn = removeDigit(nDigits, i + 2, nix)
                        rd = removeDigit(dDigits, i + 2, dix)
                        if (1.0 * n / d) == (1.0 * rn / rd):
                            count[i] += 1
                            omitted[i][digit] += 1
                            if count[i] <= 12:
                                print "%d/%d = %d/%d by omitting %d's" % (n, d, rn, rd, digit)
                    nix += 1
                d += 1
            n += 1
        print
        i += 1

    i = 2
    while i <= 5:
        print "There are %d %d-digit fractions of which:" % (count[i - 2], i)
        j = 1
        while j <= 9:
            if omitted[i - 2][j] == 0:
                j += 1
                continue
            print "%6s have %d's omitted" % (omitted[i - 2][j], j)
            j += 1
        print
        i += 1
    return None

main()
