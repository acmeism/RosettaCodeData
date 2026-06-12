PopSmall=: 1e5 ?@# 365
PopBig=: 1e8 ?@# 365

countShared=: [: >./ #/.~
avg=: +/ % #

probShared=: (1 :0)("0)
:
  NB. y: shared birthday count
  NB. m: population
  NB. x: sample size
  avg ,y <: (-x) countShared\ m
)

estGroupSz=: 3 :0
  approx=. (PopSmall probShared&y i.365) I. 0.5
  n=. approx-(2+y)
  refine=. n+(PopBig probShared&y approx+i:2+y) I. 0.5
  assert. (2+y) > |approx-refine
  refine, refine PopBig probShared y
)
