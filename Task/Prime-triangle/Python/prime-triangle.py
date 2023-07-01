from numpy import array
# for Rosetta Code by MG - 20230312
def is_prime(n: int) -> bool:
    assert n < 64
    return ((1 << n) & 0x28208a20a08a28ac) != 0

def prime_triangle_row(a: array, start: int, length: int) -> bool:
    if length == 2:
        return is_prime(a[0] + a[1])
    for i in range(1, length - 1, 1):
        if is_prime(a[start] + a[start + i]):
            a[start + i], a[start + 1] = a[start + 1], a[start + i]
            if prime_triangle_row(a, start + 1, length - 1):
                return True
            a[start + i], a[start + 1] = a[start + 1], a[start + i]
    return False

def prime_triangle_count(a: array, start: int, length: int) -> int:
    count: int = 0
    if length == 2:
        if is_prime(a[start] + a[start + 1]):
            count += 1
    else:
        for i in range(1, length - 1, 1):
            if is_prime(a[start] + a[start + i]):
                a[start + i], a[start + 1] = a[start + 1], a[start + i]
                count += prime_triangle_count(a, start + 1, length - 1)
                a[start + i], a[start + 1] = a[start + 1], a[start + i]
    return count

def print_row(a: array):
    if a == []:
        return
    print("%2d"% a[0], end=" ")
    for x in a[1:]:
        print("%2d"% x, end=" ")
    print()

for n in range(2, 21):
    tr: array = [_ for _ in range(1, n + 1)]
    if prime_triangle_row(tr, 0, n):
        print_row(tr)
print()
for n in range(2, 21):
    tr: array = [_ for _ in range(1, n + 1)]
    if n > 2:
        print(" ", end="")
    print(prime_triangle_count(tr, 0, n), end="")
print()
