import re

def rangeexpand(txt):
    lst = []
    for rng in txt.split(','):
        start,end = re.match(r'^(-?\d+)(?:-(-?\d+))?$', rng).groups()
        if end:
            lst.extend(range(int(start),int(end)+1))
        else:
            lst.append(int(start))
    return lst
