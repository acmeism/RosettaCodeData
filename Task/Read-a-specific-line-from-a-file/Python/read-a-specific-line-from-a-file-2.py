from itertools import islice

with open('xxx.txt') as f:
    try:
        line = next(islice(f, 6, 7))
    except StopIteration:
        print('Not 7 lines in file')
