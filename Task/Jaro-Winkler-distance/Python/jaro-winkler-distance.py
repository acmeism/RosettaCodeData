"""
Test Jaro-Winkler distance metric.
linuxwords.txt is from http://users.cs.duke.edu/~ola/ap/linuxwords
"""

WORDS = [s.strip() for s in open("linuxwords.txt").read().split()]
MISSPELLINGS = [
    "accomodate​",
    "definately​",
    "goverment",
    "occured",
    "publically",
    "recieve",
    "seperate",
    "untill",
    "wich",
]

def jaro_winkler_distance(st1, st2):
    """
    Compute Jaro-Winkler distance between two strings.
    """
    if len(st1) < len(st2):
        st1, st2 = st2, st1
    len1, len2 = len(st1), len(st2)
    if len2 == 0:
        return 0.0
    delta = max(0, len2 // 2 - 1)
    flag = [False for _ in range(len2)]  # flags for possible transpositions
    ch1_match = []
    for idx1, ch1 in enumerate(st1):
        for idx2, ch2 in enumerate(st2):
            if idx2 <= idx1 + delta and idx2 >= idx1 - delta and ch1 == ch2 and not flag[idx2]:
                flag[idx2] = True
                ch1_match.append(ch1)
                break

    matches = len(ch1_match)
    if matches == 0:
        return 1.0
    transpositions, idx1 = 0, 0
    for idx2, ch2 in enumerate(st2):
        if flag[idx2]:
            transpositions += (ch2 != ch1_match[idx1])
            idx1 += 1

    jaro = (matches / len1 + matches / len2 + (matches - transpositions/2) / matches) / 3.0
    commonprefix = 0
    for i in range(min(4, len2)):
        commonprefix += (st1[i] == st2[i])

    return 1.0 - (jaro + commonprefix * 0.1 * (1 - jaro))

def within_distance(maxdistance, stri, maxtoreturn):
    """
    Find words in WORDS of closeness to stri within maxdistance, return up to maxreturn of them.
    """
    arr = [w for w in WORDS if jaro_winkler_distance(stri, w) <= maxdistance]
    arr.sort(key=lambda x: jaro_winkler_distance(stri, x))
    return arr if len(arr) <= maxtoreturn else arr[:maxtoreturn]

for STR in MISSPELLINGS:
    print('\nClose dictionary words ( distance < 0.15 using Jaro-Winkler distance) to "',
          STR, '" are:\n        Word   |  Distance')
    for w in within_distance(0.15, STR, 5):
        print('{:>14} | {:6.4f}'.format(w, jaro_winkler_distance(STR, w)))
