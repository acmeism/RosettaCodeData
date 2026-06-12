from itertools import product

# check permutations until we find the word 'crack'
for x in product('ACRK', repeat=5):
    w = ''.join(x)
    print w
    if w.lower() == 'crack': break
