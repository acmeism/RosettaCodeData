A = 'I am string'
B = 'I am string too'

if len(A) > len(B):
    print('"' + A + '"', 'has length', len(A), 'and is the longest of the two strings')
    print('"' + B + '"', 'has length', len(B), 'and is the shortest of the two strings')
elif len(A) < len(B):
    print('"' + B + '"', 'has length', len(B), 'and is the longest of the two strings')
    print('"' + A + '"', 'has length', len(A), 'and is the shortest of the two strings')
else:
    print('"' + A + '"', 'has length', len(A), 'and it is as long as the second string')
    print('"' + B + '"', 'has length', len(B), 'and it is as long as the second string')
