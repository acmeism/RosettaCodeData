>>> def reps(text):
    return [text[:x] for x in range(1, 1 + len(text) // 2)
            if text.startswith(text[x:])]

>>> matchstr = """\
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
>>> print('\n'.join('%r has reps %r' % (line, reps(line)) for line in matchstr.split()))
'1001110011' has reps ['10011']
'1110111011' has reps ['1110']
'0010010010' has reps ['001']
'1010101010' has reps ['10', '1010']
'1111111111' has reps ['1', '11', '111', '1111', '11111']
'0100101101' has reps []
'0100100' has reps ['010']
'101' has reps []
'11' has reps ['1']
'00' has reps ['0']
'1' has reps []
>>>
