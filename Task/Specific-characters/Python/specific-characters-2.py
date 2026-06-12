import copy

def uniq(s):
    out = ''
    for i in s:
        if i not in out:
            out += i
    return out

def specific(l, has=True):
    """
    Given a list of strings.
    A character in each string is specific if:
        1) It appears exactly twice in this string.
        2) It does not appear in any other string in the list.
    Return the count of all specific characters in each string.
    """
    res = []
    for x,line in enumerate(l):
        t = ""
        others = copy.deepcopy(l)
        del others[x]
        for letter in line:
            is_specific = line.count(letter) == 2
            is_specific = is_specific and \
                not any([letter in i for i in others])
            if is_specific: t += letter
        if has:
            res.append(len(uniq(t)))
        else:
            res.append(len(uniq(''.join(c for c in line if c not in t))))
    return res


print(specific(["ahwiueshaiu","ajxxfioaaf","ajrdsfroiwr"]))
print(specific(["ahwiueshaiu","ajxxfioaaf","ajrdsfroiwr"],False))
