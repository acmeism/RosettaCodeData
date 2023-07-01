>>> def thue_morse_digits(digits):
...     return  [bin(n).count('1') % 2 for n in range(digits)]
...
>>> thue_morse_digits(20)
[0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1]

>>>
