def reverse(n, base):
    r = 0
    while n > 0:
        r = r*base + n%base
        n = n//base
    return r

def palindrome(n, base):
    return n == reverse(n, base)

cnt = 0
for i in range(25000):
    if all(palindrome(i, base) for base in (2,4,16)):
        cnt += 1
        print("{:5}".format(i), end=" \n"[cnt % 12 == 0])

print()
