from itertools import groupby
def encode(input_string):
    return [(len(list(g)), k) for k,g in groupby(input_string)]

def decode(lst):
    return ''.join(c * n for n,c in lst)

encode("aaaaahhhhhhmmmmmmmuiiiiiiiaaaaaa")
decode([(5, 'a'), (6, 'h'), (7, 'm'), (1, 'u'), (7, 'i'), (6, 'a')])
