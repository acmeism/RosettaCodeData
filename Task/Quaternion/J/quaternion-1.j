   NB. utilities
   ip=:   +/ .*             NB. inner product
   T=. (_1^#:0 10 9 12)*0 7 16 23 A.=i.4
   toQ=:  4&{."1 :[:        NB. real scalars -> quaternion

   NB. task
   norm=: %:@ip~@toQ        NB. | y
   neg=:  -&toQ             NB. - y  and  x - y
   conj=: 1 _1 _1 _1 * toQ  NB. + y
   add=:  +&toQ             NB. x + y
   mul=:  (ip T ip ])&toQ   NB. x * y
