import: mapping
import: file

: <<nbl     \ stream n -- stream
   #[ ' ' <<c ] times ;

String method: justify( n just -- s )
| l m |
   n self size - dup ->l 2 / ->m
   String new
   just $RIGHT  if=: [ l <<nbl  self <<  return ]
   just $LEFT   if=: [ self <<  l <<nbl  return ]
   m <<nbl  self <<  l m - <<nbl
;

: align( file just -- )
| lines maxsize |
    #[ wordsWith( '$' ) ] file File new map   ->lines
    0 #[ apply( #[ size max ] ) ] lines apply ->maxsize
    #[ apply( #[ justify( maxsize , just) . ] ) printcr ] lines apply
;
