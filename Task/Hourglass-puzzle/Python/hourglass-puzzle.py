def hourglass_puzzle():
    t4 = 0
    while t4 < 10_000:
        t7_left = 7 - t4 % 7
        if t7_left == 9 - 4:
            break
        t4 += 4
    else:
        print('Not found')
        return
    print(f"""
Turn over both hour glasses at the same time and continue flipping them each
when they individually run down until the 4 hour glass is flipped {t4//4} times,
wherupon the 7 hour glass is immediately placed on its side with {t7_left} hours
of sand in it.
You can measure 9 hours by flipping the 4 hour glass once, then
flipping the remaining sand in the 7 hour glass when the 4 hour glass ends.
 """)

hourglass_puzzle()
