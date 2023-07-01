from __future__ import print_function

def add_reverse(num, max_iter=1000):
    i, nums = 0, {num}
    while True:
        i, num = i+1, num + reverse_int(num)
        nums.add(num)
        if reverse_int(num) == num or i >= max_iter:
            break
    return nums

#@functools.lru_cache(maxsize=2**20)
def reverse_int(num):
    return int(str(num)[::-1])

def split_roots_from_relateds(roots_and_relateds):
    roots = roots_and_relateds[::]
    i = 1
    while i < len(roots):
        this = roots[i]
        if any(this.intersection(prev) for prev in roots[:i]):
            del roots[i]
        else:
            i += 1
    root = [min(each_set) for each_set in roots]
    related = [min(each_set) for each_set in roots_and_relateds]
    related = [n for n in related if n not in root]
    return root, related

def find_lychrel(maxn, max_reversions):
    'Lychrel number generator'
    series = [add_reverse(n, max_reversions*2) for n in range(1, maxn + 1)]
    roots_and_relateds = [s for s in series if len(s) > max_reversions]
    return split_roots_from_relateds(roots_and_relateds)


if __name__ == '__main__':
    maxn, reversion_limit = 10000, 500
    print("Calculations using n = 1..%i and limiting each search to 2*%i reverse-digits-and-adds"
          % (maxn, reversion_limit))
    lychrel, l_related = find_lychrel(maxn, reversion_limit)
    print('  Number of Lychrel numbers:', len(lychrel))
    print('    Lychrel numbers:', ', '.join(str(n) for n in lychrel))
    print('  Number of Lychrel related:', len(l_related))
    #print('    Lychrel related:', ', '.join(str(n) for n in l_related))
    pals = [x for x in lychrel + l_related  if x == reverse_int(x)]
    print('  Number of Lychrel palindromes:', len(pals))
    print('    Lychrel palindromes:', ', '.join(str(n) for n in pals))
