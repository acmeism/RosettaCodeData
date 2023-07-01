for n in range(1, 100):
    fb = ''.join([ denom[1] if n % denom[0] == 0 else '' for denom in [(3,'fizz'),(5,'buzz')] ])
    print fb if fb else n
