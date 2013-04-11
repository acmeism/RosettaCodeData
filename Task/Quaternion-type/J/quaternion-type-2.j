   q=: 1 2 3 4
   q1=: 2 3 4 5
   q2=: 3 4 5 6
   r=: 7

   norm q
5.47723
   neg q
_1 _2 _3 _4
   conj q
1 _2 _3 _4
   r add q
8 2 3 4
   q1 add q2
5 7 9 11
   r mul q
7 14 21 28
   q1 mul q2
_56 16 24 26
   q2 mul q1
_56 18 20 28
