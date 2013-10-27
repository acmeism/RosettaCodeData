print ('\n'.join(''.join(''.join(['' if i%3 else 'Fizz',
                                  '' if i%5 else 'Buzz'])
                         or str(i))
                 for i in range(1,101)))
