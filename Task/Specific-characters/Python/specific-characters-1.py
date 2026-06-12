def specific(s):
    all = ''.join(s)
    for i,l in enumerate(s):
        n = 0
        u = set(l)
        for c in u:
            n += l.count(c)==2 and \
                 all.count(c)==2
        s[i] = [n,len(u)-n]
    return list(zip(*s))

print(specific(["ahwiueshaiu","ajxxfioaaf","ajrdsfroiwr"]))
