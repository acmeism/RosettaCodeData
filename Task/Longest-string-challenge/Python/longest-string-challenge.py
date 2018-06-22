import fileinput

# This returns True if the second string has a value on the
# same index as the last index of the first string. It runs
# faster than trimming the strings because it runs len once
# and is a single index lookup versus slicing both strings
# one character at a time.
def longer(a, b):
    try:
        b[len(a)-1]
        return False
    except:
        return True

longest, lines = '', ''
for x in fileinput.input():
    if longer(x, longest):
        lines, longest = x, x
    elif not longer(longest, x):
        lines += x

print(lines, end='')
