def fibWord(n):
    Sn_1 = "0"
    Sn = "01"
    tmp = ""
    for i in range(2, n + 1):
        tmp = Sn
        Sn += Sn_1
        Sn_1 = tmp
    return Sn

fib = fibWord(10)
sturmian = sturmian_word(13, 21)
assert fib[:len(sturmian)] == sturmian
print(sturmian)

# Output:
# 01001010010010100101001001010010
