for n in range(1,101):
    msg = ""
    if not (n%3):
        msg += "Fizz"
    if not (n%5):
        msg += "Buzz"
    print msg or str(n)
