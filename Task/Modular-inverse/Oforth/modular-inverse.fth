// euclid ( a b -- u v r )
//    Return r = gcd(a, b) and (u, v) / r = au + bv

: euclid(a, b)
| q u u1 v v1 |

   b 0 < ifTrue: [ b neg ->b ]
   a 0 < ifTrue: [ b a neg b mod - ->a ]

   1 dup ->u ->v1
   0 dup ->v ->u1

   while(b) [
      b a b /mod ->q ->b ->a
      u1 u u1 q * - ->u1 ->u
      v1 v v1 q * - ->v1 ->v
      ]
   u v a ;

: invmod(a, modulus)
   a modulus euclid 1 == ifFalse: [ drop drop null return ]
   drop dup 0 < ifTrue: [ modulus + ] ;
