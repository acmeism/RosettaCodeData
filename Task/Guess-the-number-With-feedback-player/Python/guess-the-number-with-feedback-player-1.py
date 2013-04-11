inclusive_range = mn, mx = (1, 10)

print('''\
Think of a number between %i and %i and wait for me to guess it.
On every guess of mine you should state whether the guess was
too high, too low, or equal to your number by typing h, l, or =
''' % inclusive_range)

i = 0
while True:
    i += 1
    guess = (mn+mx)//2
    txt = input("Guess %2i is: %2i. The score for which is (h,l,=): "
                % (i, guess)).strip().lower()[0]
    if txt not in 'hl=':
        print("  I don't understand your input of '%s' ?" % txt)
        continue
    if txt == 'h':
        mx = guess-1
    if txt == 'l':
        mn = guess+1
    if txt == '=':
        print("  Ye-Haw!!")
        break
    if (mn > mx) or (mn < inclusive_range[0]) or (mx > inclusive_range[1]):
        print("Please check your scoring as I cannot find the value")
        break

print("\nThanks for keeping score.")
