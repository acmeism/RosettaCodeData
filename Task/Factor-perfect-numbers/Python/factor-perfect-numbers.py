''' Rosetta Code task Factor-perfect_numbers '''

from functools import cache
from sympy import divisors


def more_multiples(to_seq, from_seq):
    ''' Uses the first definition and recursion to generate the sequences '''
    onemores = [to_seq + [i]
                for i in from_seq if i > to_seq[-1] and i % to_seq[-1] == 0]
    if len(onemores) == 0:
        return []
    for i in range(len(onemores)):
        for arr in more_multiples(onemores[i], from_seq):
            onemores.append(arr)
    return onemores


listing = [a + [48]
           for a in sorted(more_multiples([1], divisors(48)[1:-1]))] + [[1, 48]]
print('48 sequences using first definition:')
for j, seq in enumerate(listing):
    print(f'{str(seq):22}', end='\n' if (j + 1) % 4 == 0 else '')


# Derive second definition's sequences
print('\n48 sequences using second definition:')
for k, seq in enumerate(listing):
    seq2 = [seq[i] // seq[i - 1] for i in range(1, len(seq))]
    print(f'{str(seq2):20}', end='\n' if (k + 1) % 4 == 0 else '')


@cache
def erdos_factor_count(number):
    ''' 'Erdos method '''
    return sum(erdos_factor_count(number // d) for d in divisors(number)[1:-1]) + 1


print("\nOEIS A163272:  ", end='')
for num in range(2_400_000):
    if num == 0 or erdos_factor_count(num) == num:
        print(num, end=',  ')
