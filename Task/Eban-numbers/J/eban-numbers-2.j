ebanseq=: {{ (#~ y>:])}.,@([+/~1000*])^:(6<.<.1000^.y)~(,0 2 4 6+/~10*0 3 4 5 6) }}

   (,:&":~ #) ebanseq 1000
19
2 4 6 30 32 34 36 40 42 44 46 50 52 54 56 60 62 64 66
   (,:&":~ #) (#~ 1000<])ebanseq 4000
21
2000 2002 2004 2006 2030 2032 2034 2036 2040 2042 2044 2046 2050 2052 2054 2056 2060 2062 2064 2066 4000
   # ebanseq 1e4
79
   # ebanseq 1e5
399
   # ebanseq 1e6
399
   # ebanseq 1e7
1599
   # ebanseq 1e8
7999
   # ebanseq 1e9
7999
   # ebanseq 1e10
31999
   # ebanseq 1e11
159999
   # ebanseq 1e12
159999
   # ebanseq 1e13
639999
   # ebanseq 1e14
3199999
   # ebanseq 1e15
3199999
   # ebanseq 1e16
12799999
   # ebanseq 1e17
63999999
