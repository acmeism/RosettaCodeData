4 5 6 7 8 CELL 5 darray test5d   \ Creates the array
i j k l m test5d   \ Returns the address of test5d[ i, j, k, l, m ]

100 i j k l m test5d !   \ Sets contents of test5d[ i, j, k, l, m ] to 100
 i j k l m test5d @      \ Gets contents of test5d[ i, j, k, l, m ]
