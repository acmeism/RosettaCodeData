    'Binary Integer overflow - vb6 - 28/02/2017
    Dim i As Long '32-bit signed integer
    i = -(-2147483647 - 1)           '=-2147483648   ?! bug
    i = -Int(-2147483647 - 1)        '=-2147483648   ?! bug
    i = 0 - (-2147483647 - 1)        'Run-time error '6' : Overflow
    i = -2147483647: i = -(i - 1)    'Run-time error '6' : Overflow
    i = -(-2147483647 - 2)           'Run-time error '6' : Overflow
    i = 2147483647 + 1               'Run-time error '6' : Overflow
    i = 2000000000 + 2000000000      'Run-time error '6' : Overflow
    i = -2147483647 - 2147483647     'Run-time error '6' : Overflow
    i = 46341 * 46341                'Run-time error '6' : Overflow
    i = (-2147483647 - 1) / -1       'Run-time error '6' : Overflow
