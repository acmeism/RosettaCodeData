>>> primes_upto3(10**6, smallprimes=(2,3)) # Wall time: 0.17
array([     2,      3,      5, ..., 999961, 999979, 999983])
>>> primes_upto3(10**7, smallprimes=(2,3))            # Wall time: '''2.13'''
array([      2,       3,       5, ..., 9999971, 9999973, 9999991])
>>> primes_upto3(15)
array([ 2,  3,  5,  7, 11, 13])
>>> primes_upto3(10**7, smallprimes=primes_upto3(15)) # Wall time: '''1.31'''
array([      2,       3,       5, ..., 9999971, 9999973, 9999991])
>>> primes_upto2(10**7)                               # Wall time: '''1.39''' <-- version ''without'' wheels
array([      2,       3,       5, ..., 9999971, 9999973, 9999991])
>>> primes_upto3(10**7)                               # Wall time: '''1.30'''
array([      2,       3,       5, ..., 9999971, 9999973, 9999991])
