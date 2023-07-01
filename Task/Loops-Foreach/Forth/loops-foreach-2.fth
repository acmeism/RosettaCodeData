: FOREACH  ( array size XT --)
        >R                 \ save execution token on return stack
        CELLS BOUNDS       \ convert addr,len -> last,first addresses
        BEGIN
           2DUP >          \ test addresses
        WHILE ( last>first )
           DUP R@ EXECUTE  \ apply the execution token to the address
           CELL+           \ move first to the next memory cell
        REPEAT
        R> DROP            \ clean return stack
        2DROP              \ and data stack
;

\ Make an operator to fetch contents of an address and print
: ?  ( addr --)  @ .  ;

CREATE A[]   9 , 8 , 7 , 6 , 5 , 4 , 3 , 2 , 1 , 0 ,

\ Usage example:
A[] 10   ' ? FOREACH
