|=  [n=@ x=@ y=@]
^-  @
|-
?:  =(n 0)
  (add x y)
?:  =(y 0)
  x
$(n (dec n), x $(n n, x x, y (dec y)), y (add $(n n, x x, y (dec y)) y))
