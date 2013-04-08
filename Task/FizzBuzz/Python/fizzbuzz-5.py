messages = [None, "Fizz", "Buzz", "FizzBuzz"]
acc = 810092048
for i in xrange(1, 101):
    c = acc & 3
    print messages[c] if c else i
    acc = acc >> 2 | c << 28
