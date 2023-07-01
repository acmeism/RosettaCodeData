maxSS=:monad define
  sums=: (0>.+)/\. y
  start=: sums i. max=: >./ sums
  max (] {.~ #@] |&>: (= +/\) i. 1:) y}.~start
)
