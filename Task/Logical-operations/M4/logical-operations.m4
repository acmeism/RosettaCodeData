define(`logical',
   `and($1,$2)=eval($1&&$2)  or($1,$2)=eval($1||$2)  not($1)=eval(!$1)')
logical(1,0)
