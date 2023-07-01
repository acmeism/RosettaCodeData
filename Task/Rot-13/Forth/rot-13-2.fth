: ,chars ( end start -- )
  do i c, loop ;

: xlate create does> ( c -- c' ) + c@ ;

xlate rot13
  char A         0    ,chars
  char Z 1+ char N    ,chars
  char N    char A    ,chars
  char a    char Z 1+ ,chars
  char z 1+ char n    ,chars
  char n    char a    ,chars
  256       char z 1+ ,chars

: rot13-string ( addr len -- )
  over + swap do i c@ rot13 i c! loop ;

: .rot13" ( string -- )
  [char] " parse 2dup rot13-string type ;

.rot13" abjurer NOWHERE"   \ nowhere ABJURER
