def unrank(n):
        return map(len, bin(n)[3:].split("0")) if n else []

def rank(x):
        return int('1' + '0'.join('1'*a for a in x), 2) if x else 0

for x in range(11):
        print x, unrank(x), rank(unrank(x))

print
x = [1, 2, 3, 5, 8];
print x, rank(x), unrank(rank(x))
