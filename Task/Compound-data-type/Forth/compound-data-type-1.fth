: pt>x ( point -- x ) ;
: pt>y ( point -- y ) CELL+ ;
: .pt ( point -- ) dup pt>x @ . pt>y @ . ;    \ or for this simple structure, 2@ . .

create point 6 , 0 ,
7 point pt>y !
.pt    \ 6 7
