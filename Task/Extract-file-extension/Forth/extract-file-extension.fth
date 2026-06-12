: invalid? ( c -- f )
   toupper dup [char] A [char] Z 1+ within
   swap [char] 0 [char] 9 1+ within or 0= ;
: extension ( addr1 u1 -- addr2 u2 )
   dup 0= if exit then
   2dup over +
   begin 1- 2dup <= while dup c@ invalid? until then
   \ no '.' found
   2dup - 0> if 2drop dup /string exit then
   \ invalid char
   dup c@ [char] . <> if 2drop dup /string exit then
   swap -
   \ '.' is last char
   2dup 1+ = if drop dup then
   /string ;

: type.quoted ( addr u -- )
   [char] ' emit type [char] ' emit ;
: test ( addr u -- )
   2dup type.quoted ."  => " extension type.quoted cr ;
: tests
   s" http://example.com/download.tar.gz" test
   s" CharacterModel.3DS" test
   s" .desktop" test
   s" document" test
   s" document.txt_backup" test
   s" /etc/pam.d/login" test ;
