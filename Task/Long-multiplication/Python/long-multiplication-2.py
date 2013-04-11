#!/usr/bin/env python

def add_with_carry(result, addend, addendpos):
    while True:
        while len(result) < addendpos + 1:
            result.append(0)
        addend_result = str(int(addend) + int(result[addendpos]))
        addend_digits = list(addend_result)
        result[addendpos] = addend_digits.pop()

        if not addend_digits:
            break
        addend = addend_digits.pop()
        addendpos += 1

def longhand_multiplication(multiplicand, multiplier):
    result = []
    for multiplicand_offset, multiplicand_digit in enumerate(reversed(multiplicand)):
        for multiplier_offset, multiplier_digit in enumerate(reversed(multiplier), start=multiplicand_offset):
            multiplication_result = str(int(multiplicand_digit) * int(multiplier_digit))

            for addend_offset, result_digit_addend in enumerate(reversed(multiplication_result), start=multiplier_offset):
                add_with_carry(result, result_digit_addend, addend_offset)

    result.reverse()

    return ''.join(result)

if __name__ == "__main__":
    sixtyfour = "18446744073709551616"

    onetwentyeight = longhand_multiplication(sixtyfour, sixtyfour)
    print(onetwentyeight)
