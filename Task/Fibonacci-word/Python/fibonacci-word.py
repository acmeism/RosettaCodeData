>>> import math
>>> from collections import Counter
>>>
>>> def entropy(s):
...     p, lns = Counter(s), float(len(s))
...     return -sum( count/lns * math.log(count/lns, 2) for count in p.values())
...
>>>
>>> def fibword(nmax=37):
...     fwords = ['1', '0']
...     print('%-3s %10s %-10s %s' % tuple('N Length Entropy Fibword'.split()))
...     def pr(n, fwords):
...         while len(fwords) < n:
...             fwords += [''.join(fwords[-2:][::-1])]
...         v = fwords[n-1]
...         print('%3i %10i %10.7g %s' % (n, len(v), entropy(v), v if len(v) < 20 else '<too long>'))
...     for n in range(1, nmax+1): pr(n, fwords)
...
>>> fibword()
N       Length Entropy    Fibword
  1          1         -0 1
  2          1         -0 0
  3          2          1 01
  4          3  0.9182958 010
  5          5  0.9709506 01001
  6          8   0.954434 01001010
  7         13  0.9612366 0100101001001
  8         21  0.9587119 <too long>
  9         34  0.9596869 <too long>
 10         55   0.959316 <too long>
 11         89  0.9594579 <too long>
 12        144  0.9594038 <too long>
 13        233  0.9594244 <too long>
 14        377  0.9594165 <too long>
 15        610  0.9594196 <too long>
 16        987  0.9594184 <too long>
 17       1597  0.9594188 <too long>
 18       2584  0.9594187 <too long>
 19       4181  0.9594187 <too long>
 20       6765  0.9594187 <too long>
 21      10946  0.9594187 <too long>
 22      17711  0.9594187 <too long>
 23      28657  0.9594187 <too long>
 24      46368  0.9594187 <too long>
 25      75025  0.9594187 <too long>
 26     121393  0.9594187 <too long>
 27     196418  0.9594187 <too long>
 28     317811  0.9594187 <too long>
 29     514229  0.9594187 <too long>
 30     832040  0.9594187 <too long>
 31    1346269  0.9594187 <too long>
 32    2178309  0.9594187 <too long>
 33    3524578  0.9594187 <too long>
 34    5702887  0.9594187 <too long>
 35    9227465  0.9594187 <too long>
 36   14930352  0.9594187 <too long>
 37   24157817  0.9594187 <too long>
>>>
