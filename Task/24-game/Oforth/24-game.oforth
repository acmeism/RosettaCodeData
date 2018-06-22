import: mapping

: game
| l expr w n i |
   4 #[ 9 rand ] Array init ->l

   System.Out "Digits : " << l << " --> RPN Expression for 24 : " << drop
   System.Console accept ->expr

   expr words forEach: w [
      w "+" == ifTrue: [ + continue ]
      w "-" == ifTrue: [ - continue ]
      w "*" == ifTrue: [ * continue ]
      w "/" == ifTrue: [ >float / continue ]

      w >integer dup ->n  ifNull: [ System.Out "Word " << w << " not allowed " << cr break ]
      n l indexOf dup ->i ifNull: [ System.Out "Integer " << n << " is wrong " << cr break ]
      n l put(i, null)
      ]
   #null? l conform? ifFalse: [ "Sorry, all numbers must be used..." . return ]
   24 if=: [ "You won !" ] else: [ "You loose..." ] .
;
