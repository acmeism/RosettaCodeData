''' python example for task rosettacode.org/wiki/Blum_integer '''

from sympy import factorint


def generate_blum():
    ''' Generate the Blum integers in series '''
    for candidate in range(1, 10_000_000_000):
        fexp = factorint(candidate).items()
        if len(fexp) == 2 and sum(p[1] == 1 and p[0] % 4 == 3 for p in fexp) == 2:
            yield candidate


print('First 50 Blum integers:')
lastdigitsums = [0, 0, 0, 0]

for idx, blum in enumerate(generate_blum()):
    if idx < 50:
        print(f'{blum: 4}', end='\n' if (idx + 1) % 10 == 0 else '')
    elif idx + 1 in [26_828, 100_000, 200_000, 300_000, 400_000]:
        print(f'\nThe {idx+1:,}th Blum number is {blum:,}.')

    j = blum % 10
    lastdigitsums[0] += j == 1
    lastdigitsums[1] += j == 3
    lastdigitsums[2] += j == 7
    lastdigitsums[3] += j == 9

    if idx + 1 == 400_000:
        print('\n% distribution of the first 400,000 Blum integers is:')
        for k, dig in enumerate([1, 3, 7, 9]):
            print(f'{lastdigitsums[k]/4000:>8.5}% end in {dig}')

        break
