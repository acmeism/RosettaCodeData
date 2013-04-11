import fileinput

# return len(a) - len(b) if positive, 0 otherwise
def longer(a, b):
    while len(a) and len(b):
        a, b = a[1:], b[1:]
    return len(a)

longest, lines = '', ''
for x in fileinput.input():
    if longer(x, longest):
        lines, longest = x, x
    elif not longer(longest, x):
        lines += x

print(lines, end='')
