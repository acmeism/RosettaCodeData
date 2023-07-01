def countJewels(s, j):
    return sum(x in j for x in s)

print countJewels("aAAbbbb", "aA")
print countJewels("ZZ", "z")
