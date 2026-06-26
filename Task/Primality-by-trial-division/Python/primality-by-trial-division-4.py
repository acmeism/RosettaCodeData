>>> import re
>>> def isprime(n):
    return not re.match(r'^1?$|^(11+?)\1+$', '1' * n)

>>> # A quick test
>>> [i for i in range(40) if isprime(i)]
