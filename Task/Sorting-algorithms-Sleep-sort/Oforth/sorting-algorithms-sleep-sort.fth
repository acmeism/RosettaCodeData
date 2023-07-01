import: parallel

: sleepSort(l)
| ch n |
   Channel new ->ch
   l forEach: n [ #[ n dup 20 * sleep ch send drop ] & ]
   ListBuffer newSize(l size) #[ ch receive over add ] times(l size) ;
