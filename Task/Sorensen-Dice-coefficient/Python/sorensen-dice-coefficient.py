''' Rosetta Code task rosettacode.org/wiki/Sorensenâ€“Dice_coefficient '''

from multiset import Multiset


def tokenizetext(txt):
    ''' convert a phrase into a count of bigram tokens of its words '''
    arr = []
    for wrd in txt.lower().split(' '):
        arr += ([wrd] if len(wrd) == 1 else [wrd[i:i+2]
                for i in range(len(wrd)-1)])
    return Multiset(arr)


def sorenson_dice(text1, text2):
    ''' Sorenson-Dice similarity of Multisets '''
    bc1, bc2 = tokenizetext(text1), tokenizetext(text2)
    return 2 * len(bc1 & bc2) / (len(bc1) + len(bc2))


with open('tasklist_sorenson.txt', 'r') as fd:
    alltasks = fd.read().split('\n')

for testtext in ['Primordial primes', 'Sunkist-Giuliani formula',
                 'Sieve of Euripides', 'Chowder numbers']:
    taskvalues = sorted([(sorenson_dice(testtext, t), t)
                        for t in alltasks], reverse=True)
    print(f'\n{testtext}:')
    for (val, task) in taskvalues[:5]:
        print(f'  {val:.6f}  {task}')
