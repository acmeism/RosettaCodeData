import re
from collections import defaultdict

with open('unixdict.txt') as f:
    lines = [l.rstrip() for l in f] # all lines of text without newline

# keep only lines that's long enough and has no non-letters
words = [w for w in lines if len(w) > 10 and not re.match(r'[^a-z]', w)]

good = defaultdict(list)
for word in words:
    # take all consonants in word
    c = re.sub(r'[aeiou]', '', word)

    # check if there are duplicates
    if sorted(c) == sorted(set(c)):
        good[len(c)].append(word)

for k, v in sorted(good.items(), reverse=True):
    if len(v) > 30:
        print(f'{k}: {len(v)} words')
    else:
        print(f'{k}:', ' '.join(sorted(v)))
