ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

def convertToBase58(num):
    sb = ''
    while (num > 0):
        r = num % 58
        sb = sb + ALPHABET[r]
        num = num // 58;
    return sb[::-1]

s = 25420294593250030202636073700053352635053786165627414518
b = convertToBase58(s)
print("%-56d -> %s" % (s, b))

hash_arr = [0x61, 0x626262, 0x636363, 0x73696d706c792061206c6f6e6720737472696e67, 0x516b6fcd0f, 0xbf4f89001e670274dd, 0x572e4794, 0xecac89cad93923c02321, 0x10c8511e]
for num in hash_arr:
    b = convertToBase58(num)
    print("0x%-54x -> %s" % (num, b))
