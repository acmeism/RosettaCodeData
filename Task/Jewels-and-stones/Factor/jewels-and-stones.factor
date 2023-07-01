USING: kernel prettyprint sequences ;

: count-jewels ( stones jewels -- n ) [ member? ] curry count ;

"aAAbbbb" "aA"
"ZZ" "z" [ count-jewels . ] 2bi@
