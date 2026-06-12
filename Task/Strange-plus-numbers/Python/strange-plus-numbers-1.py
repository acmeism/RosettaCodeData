Python 3.8.5 (default, Sep  3 2020, 21:29:08) [MSC v.1916 64 bit (AMD64)] on win32
Type "help", "copyright", "credits" or "license()" for more information.
>>> from sympy import isprime

>>> [x for x in range(101,500)
 if isprime(sum(int(c) for c in str(x)[:2])) and
    isprime(sum(int(c) for c in str(x)[1:]))]
[111, 112, 114, 116, 120, 121, 123, 125, 129, 141, 143, 147, 149, 161, 165, 167, 202, 203, 205, 207, 211, 212, 214, 216, 230, 232, 234, 238, 250, 252, 256, 258, 292, 294, 298, 302, 303, 305, 307, 320, 321, 323, 325, 329, 341, 343, 347, 349, 383, 385, 389, 411, 412, 414, 416, 430, 432, 434, 438, 470, 474, 476, 492, 494, 498]
>>>
