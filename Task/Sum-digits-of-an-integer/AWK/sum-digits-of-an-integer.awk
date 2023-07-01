#!/usr/bin/awk -f

BEGIN {
    print sumDigits("1")
    print sumDigits("12")
    print sumDigits("fe")
    print sumDigits("f0e")
}

function sumDigits(num,    nDigs, digits, sum, d, dig, val, sum) {
    nDigs = split(num, digits, "")
    sum = 0
    for (d = 1; d <= nDigs; d++) {
        dig = digits[d]
        val = digToDec(dig)
        sum += val
    }
    return sum
}

function digToDec(dig) {
    return index("0123456789abcdef", tolower(dig)) - 1
}
