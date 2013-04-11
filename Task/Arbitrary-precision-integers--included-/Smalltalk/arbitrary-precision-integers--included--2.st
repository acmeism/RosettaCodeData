|num numstr|
num := (2 to: 5) fold: [:exp :base| base raisedTo: exp].
numstr := num asString.
'<1s>...<2s>  digits:<3p>'
   expandMacrosWith: (numstr first: 20)
   with: (numstr last: 20)
   with: numstr size.
