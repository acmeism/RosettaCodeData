def van_eck():
    n = 0
    seen = [0]
    val = 0
    while True:
        yield val
        if val in seen[1:]:
            val = seen.index(val, 1)
        else:
            val = 0
        seen.insert(0, val)
        n += 1
