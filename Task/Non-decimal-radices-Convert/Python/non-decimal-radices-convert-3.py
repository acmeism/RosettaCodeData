digits = [[ch] for ch in "0123456789abcdefghijklmnopqrstuvwxyz"]

def baseN(num, b):
    if num == 0:
        return "0"
    result = []
    while num != 0:
        num, d = divmod(num, b)
        result += digits[d]
    return ''.join(result[::-1])
