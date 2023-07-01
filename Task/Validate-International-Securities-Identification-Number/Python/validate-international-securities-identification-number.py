def check_isin(a):
    if len(a) != 12 or not all(c.isalpha() for c in a[:2]) or not all(c.isalnum() for c in a[2:]):
        return False
    s = "".join(str(int(c, 36)) for c in a)
    return 0 == (sum(sum(divmod(2 * (ord(c) - 48), 10)) for c in s[-2::-2]) +
                 sum(ord(c) - 48 for c in s[::-2])) % 10

# A more readable version
def check_isin_alt(a):
    if len(a) != 12:
        return False
    s = []
    for i, c in enumerate(a):
        if c.isdigit():
            if i < 2:
                return False
            s.append(ord(c) - 48)
        elif c.isupper():
            if i == 11:
                return False
            s += divmod(ord(c) - 55, 10)
        else:
            return False
    v = sum(s[::-2])
    for k in s[-2::-2]:
        k = 2 * k
        v += k - 9 if k > 9 else k
    return v % 10 == 0

[check_isin(s) for s in ["US0378331005", "US0373831005", "U50378331005", "US03378331005",
                         "AU0000XVGZA3", "AU0000VXGZA3", "FR0000988040"]]

# [True, False, False, False, True, True, True]
