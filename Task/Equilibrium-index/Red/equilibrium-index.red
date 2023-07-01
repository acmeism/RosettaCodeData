Red []
eqindex: func [a [block!]] [
  collect [
    repeat ind length? a [ if (sum skip a ind) = sum copy/part a ind - 1 [ keep ind ] ]
  ]
]
prin "(1 based) equ indices are:  "
probe eqindex [-7 1 5 2 -4 3 0]
