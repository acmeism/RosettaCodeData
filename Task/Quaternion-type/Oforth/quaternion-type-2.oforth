: test
| q q1 q2 r |

   Quaternion new(1, 2, 3, 4) ->q
   Quaternion new(2, 3, 4, 5) ->q1
   Quaternion new(3, 4, 5, 6) ->q2
   7.0 -> r

   System.Out "q       = " << q << cr
   System.Out "q1      = " << q1 << cr
   System.Out "q2      = " << q2 << cr

   System.Out "norm q  = " << q norm << cr
   System.Out "neg q   = " << q neg << cr
   System.Out "conj q  = " << q conj << cr
   System.Out "q +r    = " << q r + << cr
   System.Out "q1 + q2 = " << q1 q2 + << cr
   System.Out "q * r   = " << q r * << cr
   System.Out "q1 * q2 = " << q1 q2 * << cr
   q1 q2 * q2 q1 * == ifFalse: [ "q1q2 and q2q1 are different quaternions" println ] ;
