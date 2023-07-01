bigToLeft=: (([ (>. , <.) {.@]) , }.@])/
smallToLeft=: (([ (<. , >.) {.@]) , }.@])/
cocktailSort=: |. @: (|. @: smallToLeft @: |. @: bigToLeft ^:_)
