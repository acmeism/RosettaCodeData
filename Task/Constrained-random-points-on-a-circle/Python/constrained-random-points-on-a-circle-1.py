>>> from collections import defaultdict
>>> from random import choice
>>> world = defaultdict(int)
>>> possiblepoints = [(x,y) for x in range(-15,16)
		  for y in range(-15,16)
		  if 10 <= abs(x+y*1j) <= 15]
>>> for i in range(100): world[choice(possiblepoints)] += 1

>>> for x in range(-15,16):
	print(''.join(str(min([9, world[(x,y)]])) if world[(x,y)] else ' '
			  for y in range(-15,16)))

	

             1     1
          1 1
      11 1     1  1     1
     111  1     1211
      1   2    1 1    11
      1  11         21
     1   1            11  1
   1  2                1 1

 1  2
   1 1                      1
   1 1
   2                      11
  1                         1
                         1


  1                          1
                         1
                         2
                            1
     1                  1 1
      1                2   1
   1   3            11  2
    11   1    1      1   2
            1   1    2
        1  1
         1      1     1
          2 2   1
               1
