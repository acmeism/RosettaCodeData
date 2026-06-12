''' rosettacode.org/wiki/Self-contained_numbers '''

from itertools import islice, count


def is_self_contained(n: int) -> bool:
    ''' returns True if n is self-contained '''
    m = n
    while m > 1:
        m = m // 2 if m % 2 == 0 else m * 3 + 1
        if m % n == 0:
            return True
    return False


result = list(islice(filter(is_self_contained, count(1, 2)), 7))

print(result)
