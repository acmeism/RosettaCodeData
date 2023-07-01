USING: kernel prettyprint sequences arrays sets hash-sets ;
IN: powerset

: add ( set elt -- newset ) 1array <hash-set> union ;
: powerset ( set -- newset ) members { HS{ } } [ dupd [ add ] curry map append ] reduce <hash-set> ;
