from string import ascii_uppercase as abc

def caesar(s, k, decode = False):
    trans = dict(zip(abc, abc[(k,26-k)[decode]:] + abc[:(k,26-k)[decode]]))
    return ''.join(trans[L] for L in s.upper() if L in abc)

msg = "The quick brown fox jumped over the lazy dogs"
print(caesar(msg, 11))
print(caesar(caesar(msg, 11), 11, True))
