def mycmp(s1, s2):
    return cmp(len(s2), len(s1)) or cmp(s1.upper(), s2.upper())

print sorted(strings, cmp=mycmp)
