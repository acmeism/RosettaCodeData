import re

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
1"""

def _checker(matchobj):
    g0, (g1, g2, g3, g4) = matchobj.group(0), matchobj.groups()
    if not g4 and g1 and g1.startswith(g3):
        return '%r repeats %r' % (g0, g1)
    return '%r is not a rep-string' % (g0,)

def checkit(txt):
    print(re.sub(r'(.+)(\1+)(.*)|(.*)', _checker, txt))

checkit(matchstr)
