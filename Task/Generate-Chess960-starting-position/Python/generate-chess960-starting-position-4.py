from random import choice

def generate960():
    start = ('R', 'K', 'R')         # Subsequent order unchanged by insertions.

    # Insert QNN in all combinations of places
    starts = {start}
    for piece in ['Q', 'N', 'N']:
        starts2 = set()
        for s in starts:
            for pos in range(len(s)+1):
                s2 = list(s)
                s2.insert(pos, piece)
                starts2.add(tuple(s2))
        starts = starts2

    # For each of the previous starting positions insert the bishops in their 16 positions
    starts2 = set()
    for s in starts:
        for bishpos in range(len(s)+1):
            s2 = list(s)
            s2.insert(bishpos, 'B')
            for bishpos2 in range(bishpos+1, len(s)+2, 2):
                s3 = s2[::]
                s3.insert(bishpos2, 'B')
                starts2.add(tuple(s3))

    return  list(starts2)

gen = generate960()
print(''.join(choice(gen)))
