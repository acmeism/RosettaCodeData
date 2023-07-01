import: parallel

: createSMA(period)
| ch |
   Channel new [ ] over send drop ->ch
   #[ ch receive + left(period) dup avg swap ch send drop ] ;
