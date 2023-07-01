: genLCG(a, c, m, seed)
| ch |
   Channel newSize(1) dup send(seed) drop ->ch
   #[ ch receive a * c + m mod dup ch send drop ] ;
