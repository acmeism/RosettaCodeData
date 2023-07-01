digits = "0123456789abcdefghijklmnopqrstuvwxyz"

def baseN(num, b):
    result = []
    while num >= b:
        num, d = divmod(num, b)
        result.append(digits[d])
    result.append(digits[num])
    return ''.join(result[::-1])
