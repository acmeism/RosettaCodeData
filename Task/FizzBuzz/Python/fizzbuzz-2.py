for i in range(1, 101):
    words = [word for n, word in ((3, 'Fizz'), (5, 'Buzz')) if not i % n]
    print ''.join(words) or i
