quaternion: context [
   quaternion!: make typeset! [block! hash! vector!]
   multiply: function [q [integer! float! quaternion!] p [integer! float! quaternion!]][
      case [
         number? q [collect [forall p [keep p/1 * q]]]
         number? p [collect [forall q [keep q/1 * p]]]
         'else [
            reduce [
               (q/1 * p/1) - (q/2 * p/2) - (q/3 * p/3) - (q/4 * p/4)
               (q/1 * p/2) + (q/2 * p/1) + (q/3 * p/4) - (q/4 * p/3)
               (q/1 * p/3) + (q/3 * p/1) + (q/4 * p/2) - (q/2 * p/4)
               (q/1 * p/4) + (q/4 * p/1) + (q/2 * p/3) - (q/3 * p/2)
            ]
         ]
      ]
   ]
   add: func [q [integer! float! quaternion!] p [integer! float! quaternion!]][
      case [
         number? q [head change copy p p/1 + q]
         number? p [head change copy q q/1 + p]
         'else [collect [forall q [keep q/1 + p/(index? q)]]]
      ]
   ]
   negate: func [q [quaternion!]][collect [forall q [keep 0 - q/1]]]
   conjugate: func [q [quaternion!]][collect [keep q/1  q: next q  forall q [keep 0 - q/1]]]
   norm: func [q [quaternion!]][sqrt first multiply q conjugate copy q]
   normalize: function [q [quaternion!]][n: norm q   collect [forall q [keep q/1 / n]]]
   inverse: func [q [quaternion!]][(conjugate q) / ((norm q) ** 2)]
]

set [q q1 q2 r] [[1 2 3 4] [2 3 4 5] [3 4 5 6] 7]

print [{
1. The norm of a quaternion:
`quaternion/norm q` =>} quaternion/norm q {

2. The negative of a quaternion:
`quaternion/negate q` =>} mold quaternion/negate q {

3. The conjugate of a quaternion:
<code>quaternion/conjugate q</code> =>} mold quaternion/conjugate q {

4. Addition of a real number `r` and a quaternion `q`:
`quaternion/add r q` =>} mold quaternion/add r q {
`quaternion/add q r` =>} mold quaternion/add q r {

5. Addition of two quaternions:
`quaternion/add q1 q2` =>} mold quaternion/add q1 q2 {

6. Multiplication of a real number and a quaternion:
`quaternion/multiply q r` =>} mold quaternion/multiply q r {
`quaternion/multiply r q` =>} mold quaternion/multiply r q {

7. Multiplication of two quaternions `q1` and `q2` is given by:
`quaternion/multiply q1 q2` =>} mold quaternion/multiply q1 q2 {

8. Show that, for the two quaternions `q1` and `q2`:
`equal? quaternion/multiply q1 q2 mold quaternion/multiply q2 q1` =>}
equal? quaternion/multiply q1 q2 quaternion/multiply q2 q1]
