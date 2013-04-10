: get ( key len table -- data )     \ 0 if not present
  search-wordlist if
    >body @
  else 0 then ;

: put ( data key len table -- )
  >r 2dup r@ search-wordlist if
    r> drop nip nip
    >body !
  else
    r> get-current >r set-current      \ switch definition word lists
    nextname create ,
    r> set-current
  then ;
 wordlist constant bar
5 s" alpha" bar put
9 s" beta"  bar put
2 s" gamma" bar put
s" alpha" bar get .    \ 5
8 s" Alpha" bar put    \ Forth dictionaries are normally case-insensitive
s" alpha" bar get .   \ 8
