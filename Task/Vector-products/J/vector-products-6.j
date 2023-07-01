a=:  3 4 5
b=:  4 3 5
c=: -5 12 13

A=: 0 {:: ]    NB. contents of the first box on the right
B=: 1 {:: ]    NB. contents of the second box on the right
C=: 2 {:: ]    NB. contents of the third box on the right

dotP=: A ip B
crossP=: A cross B
scTriP=: A ip B cross C
veTriP=: A cross B cross C
