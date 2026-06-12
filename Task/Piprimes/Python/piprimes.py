def prime(n):
    if n == 1:
        return False
    if n == 2:
        p.append(n)
        return True
    for y in p:
        if n % y == 0:
            return False
        if y > int(n ** 0.5):
            p.append(n)
            return True


p = []
pi = 0
x = 1

while pi < 22:
    if prime(x) == True:
        pi += 1
    x += 1
    if pi < 22:
        print(pi)
