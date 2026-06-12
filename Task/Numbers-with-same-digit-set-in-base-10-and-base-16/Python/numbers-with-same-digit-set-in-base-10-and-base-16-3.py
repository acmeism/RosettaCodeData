for nh in ([
    (n, h) for n in range(0, 1 + 100000)
    if (
        (h := hex(n)[2:])
        and set(str(n)) == set(h)
    )
]):
    print(nh)
