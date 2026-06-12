''' Rosetta code task: rosettacode.org/wiki/Idoneal_numbers '''


def is_idoneal(num):
    ''' Return true if num is an idoneal number '''
    for a in range(1, num):
        for b in range(a + 1, num):
            if a * b + a + b > num:
                break
            for c in range(b + 1, num):
                sum3 = a * b + b * c + a * c
                if sum3 == num:
                    return False
                if sum3 > num:
                    break
    return True


row = 0
for n in range(1, 2000):
    if is_idoneal(n):
        row += 1
        print(f'{n:5}', end='\n' if row % 13 == 0 else '')
