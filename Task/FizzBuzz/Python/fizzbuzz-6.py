print (', '.join([(x%3<1)*'Fizz'+(x%5<1)*'Buzz' or str(x) for x in range(1,101)]))
