def mdroot(n):
    count, mdr = 0, n
    while mdr > 9:
        m, digitsMul = mdr, 1
        while m:
            m, md = divmod(m, 10)
            digitsMul *= md
        mdr = digitsMul
        count += 1
    return count, mdr
