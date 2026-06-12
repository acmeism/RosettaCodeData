""" rosettacode.org/wiki/English_cardinal_anagrams  """
from collections import Counter
from num2words import num2words


def anagrammed(astring):
    """ Get the letter counts of astring for use as an anagram representation.
            Ignores spaces, hyphens, capitalization """
    lstr = astring.lower()
    charcounts = [sum(c == letter for c in lstr)
                  for letter in 'abcdefghijklmnopqrstuvwxyz']
    return ''.join([f'{j:0>2d}' for j in charcounts])


def process_task(maxrange, showfirst30=True):
    """ task at rosettacode.org/wiki/English_cardinal_anagrams """
    numwords = [num2words(n) for n in range(maxrange+1)]
    anastrings = [anagrammed(astr) for astr in numwords]
    rep_to_count = Counter(anastrings)
    counts = [rep_to_count[anastrings[i]] for i in range(maxrange+1)]
    if showfirst30:
        print("First 30 English cardinal anagrams:")
        i, printed = 1, 0
        while i < maxrange and printed < 30:
            if counts[i] > 1:
                printed += 1
                print(f'{i:4}', end='\n' if printed % 10 == 0 else '')
            i += 1

    print(f'\nCount of English cardinal anagrams up to {maxrange}: ', end='')
    print(sum(n > 1 for n in rep_to_count.values()))
    print(f'\nLargest group(s) of English cardinal anagrams up to {maxrange}:')
    maxcount = max(counts)
    for rep in set(anastrings[i] for i in range(maxrange+1) if counts[i] == maxcount):
        print([i for i in range(maxrange+1) if anastrings[i] == rep])


process_task(1000)
process_task(10000, False)
