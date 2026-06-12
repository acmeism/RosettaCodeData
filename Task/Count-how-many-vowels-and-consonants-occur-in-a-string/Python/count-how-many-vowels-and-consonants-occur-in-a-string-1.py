def isvowel(c):
    """ true if c is an English vowel (ignore y) """
    return c in ['a', 'e', 'i', 'o', 'u', 'A', 'E', "I", 'O', 'U']

def isletter(c):
    """ true if in English standard alphabet """
    return 'a' <= c <= 'z' or 'A' <= c <= 'Z'

def isconsonant(c):
    """ true if an English consonant """
    return  not isvowel(c) and isletter(c)

def vccounts(s):
    """ case insensitive vowel counts, total and unique """
    a = list(s.lower())
    au = set(a)
    return sum([isvowel(c) for c in a]), sum([isconsonant(c) for c in a]), \
        sum([isvowel(c) for c in au]), sum([isconsonant(c) for c in au])

def testvccount():
    teststrings = [
        "Forever Python programming language",
        "Now is the time for all good men to come to the aid of their country."]
    for s in teststrings:
        vcnt, ccnt, vu, cu = vccounts(s)
        print(f"String: {s}\n    Vowels: {vcnt} (distinct {vu})\n    Consonants: {ccnt} (distinct {cu})\n")

testvccount()
