#! /usr/bin/env python3

def lindenmayer(s, rules, count):
    for i in range(count):
        print(s)
        nxt = ""
        for c in s:
            found = False
            for j in range(0, len(rules), 2):
                if c == rules[j]:
                    rep = rules[j + 1]
                    found = True
                    break
            nxt += rep if found else c
        s = nxt

rules = ["I", "M", "M", "MI"]
lindenmayer("I", rules, 5)
