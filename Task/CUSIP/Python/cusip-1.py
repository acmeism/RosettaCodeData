#!/usr/bin/env python3

import math

def cusip_check(cusip):
    if len(cusip) != 9:
        raise ValueError('CUSIP must be 9 characters')

    cusip = cusip.upper()
    total = 0
    for i in range(8):
        c = cusip[i]
        if c.isdigit():
            v = int(c)
        elif c.isalpha():
            p = ord(c) - ord('A') + 1
            v = p + 9
        elif c == '*':
            v = 36
        elif c == '@':
            v = 37
        elif c == '#':
            v = 38

        if i % 2 != 0:
            v *= 2

        total += int(v / 10) + v % 10
    check = (10 - (total % 10)) % 10
    return str(check) == cusip[-1]

if __name__ == '__main__':
    codes = [
            '037833100',
            '17275R102',
            '38259P508',
            '594918104',
            '68389X106',
            '68389X105'
            ]
    for code in codes:
        print(f'{code} -> {cusip_check(code)}')
