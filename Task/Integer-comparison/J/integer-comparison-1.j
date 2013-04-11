compare=: < , = , >

cti=: dyad define
  select  =. ;@#
  English =. ' is less than ';' is equal to ';' is greater than '
  x (":@[, (compare select English"_), ":@]) y
)
