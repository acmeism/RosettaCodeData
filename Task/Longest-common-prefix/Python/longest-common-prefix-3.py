from itertools import takewhile

def lcp(*s):
    return ''.join(a for a,b in takewhile(lambda x: x[0] == x[1],
					  zip(min(s), max(s))))
