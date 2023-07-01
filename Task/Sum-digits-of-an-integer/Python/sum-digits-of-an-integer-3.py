def sumDigits(num, base=10):
    return sum(int(x, base) for x in str(num))

print(sumDigits(1))
print(sumDigits(12345))
print(sumDigits(123045))
print(sumDigits('fe', 16))
print(sumDigits("f0e", 16))
