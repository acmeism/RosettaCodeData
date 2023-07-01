MACRO: pre ( quot -- quot ) 1 cut swap [ 0 ] dip reduce 1quotation ;

[ + 1 2 3 4 5 ] pre ! 15
