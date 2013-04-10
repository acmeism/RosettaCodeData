>>> n = 2491969579123783355964723219455906992268673266682165637887
>>> length = 25
>>> list( reversed(range(length)) )
[24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
>>> assert n.to_bytes(length, 'big') == bytes( (n >> i*8) & 0xff for i in reversed(range(length)))
>>>
