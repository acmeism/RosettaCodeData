def indexOf(haystack, needle)
    idx = 0
    for straw in haystack
        if straw == needle then
            return idx
        else
            idx = idx + 1
        end
    end
    return -1
end

def getDigits(n, le, digits)
    while n > 0
        r = n % 10
        if r == 0 or indexOf(digits, r) >= 0 then
            return false
        end
        le = le - 1
        digits[le] = r
        n = (n / 10).floor
    end
    return true
end

POWS = [1, 10, 100, 1000, 10000]
def removeDigit(digits, le, idx)
    sum = 0
    pow = POWS[le - 2]
    i = 0
    while i < le
        if i == idx then
            i = i + 1
            next
        end
        sum = sum + digits[i] * pow
        pow = (pow / 10).floor
        i = i + 1
    end
    return sum
end

def main
    lims = [ [ 12, 97 ], [ 123, 986 ], [ 1234, 9875 ], [ 12345, 98764 ] ]
    count = Array.new(5, 0)
    omitted = Array.new(5) { Array.new(10, 0) }

    i = 0
    for lim in lims
        n = lim[0]
        while n < lim[1]
            nDigits = [0] * (i + 2)
            nOk = getDigits(n, i + 2, nDigits)
            if not nOk then
                n = n + 1
                next
            end
            d = n + 1
            while d <= lim[1] + 1
                dDigits = [0] * (i + 2)
                dOk = getDigits(d, i + 2, dDigits)
                if not dOk then
                    d = d + 1
                    next
                end
                nix = 0
                while nix < nDigits.length
                    digit = nDigits[nix]
                    dix = indexOf(dDigits, digit)
                    if dix >= 0 then
                        rn = removeDigit(nDigits, i + 2, nix)
                        rd = removeDigit(dDigits, i + 2, dix)
                        if (1.0 * n / d) == (1.0 * rn / rd) then
                            count[i] = count[i] + 1
                            omitted[i][digit] = omitted[i][digit] + 1
                            if count[i] <= 12 then
                                print "%d/%d = %d/%d by omitting %d's\n" % [n, d, rn, rd, digit]
                            end
                        end
                    end
                    nix = nix + 1
                end
                d = d + 1
            end
            n = n + 1
        end
        print "\n"
        i = i + 1
    end

    i = 2
    while i <= 5
        print "There are %d %d-digit fractions of which:\n" % [count[i - 2], i]
        j = 1
        while j <= 9
            if omitted[i - 2][j] == 0 then
                j = j + 1
                next
            end
            print "%6s have %d's omitted\n" % [omitted[i - 2][j], j]
            j = j + 1
        end
        print "\n"
        i = i + 1
    end
end

main()
