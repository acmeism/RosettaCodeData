import re

def rangeexpand(txt):
    lst = []
    for rng in txt.split(','):
        start,end = re.match('^(-?\d+)(?:-(-?\d+))?$', rng).groups()
        if end:
            lst.extend(xrange(int(start),int(end)+1))
        else:
            lst.append(int(start))
    return lst
