def is_repeated(text):
    'check if the first part of the string is repeated throughout the string'
    for x in range(len(text)//2, 0, -1):
        if text.startswith(text[x:]): return x
    return 0

matchstr = """\
1001110011
1110111011
0010010010
1010101010
1111111111
0100101101
0100100
101
11
00
1
"""
for line in matchstr.split():
    ln = is_repeated(line)
    print('%r has a repetition length of %i i.e. %s'
           % (line, ln, repr(line[:ln]) if ln else '*not* a rep-string'))
