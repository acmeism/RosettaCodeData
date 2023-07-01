digits = "0123456789abcdefghijklmnopqrstuvwxyz"
def baseN(num, b):
    return digits[num] if num < b else baseN(num // b, b) + digits[num % b]
