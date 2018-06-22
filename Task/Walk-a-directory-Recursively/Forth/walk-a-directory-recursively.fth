require unix/filestat.fs
require unix/libc.fs

: $append ( from len to -- )   2DUP >R >R  COUNT + SWAP MOVE  R> R@ C@ + R> C! ;

defer ls-filter

: dots? ( name len -- ? )   drop c@ [char] . = ;

file-stat buffer: statbuf

: isdir ( addr u -- flag )
    statbuf lstat ?ior  statbuf st_mode w@ S_IFMT and S_IFDIR = ;

: (ls-r) ( dir len -- )
  pad c@ >r  pad $append  s" /" pad $append
  pad count open-dir if  drop  r> pad c!  exit  then  ( dirid)
  begin
    dup pad count + 256 rot read-dir throw
  while
    pad count + over dots? 0= if   \ ignore all hidden names
      dup pad count rot + 2dup ls-filter if
        cr 2dup type
      then
      isdir if
        pad count + swap recurse
      else drop then
    else drop then
  repeat
  drop  r> pad c!
  close-dir throw
;

: ls-r ( dir len -- )  0 pad c!  (ls-r) ;

: c-files ( str len -- ? )
  dup 3 < if 2drop false exit then
  + 1- dup c@ 32 or
   dup [char] c <> swap [char] h <> and if drop false exit then
  1- dup c@ [char] . <> if drop false exit then
  drop true ;
' c-files is ls-filter

: all-files ( str len -- ? )   2drop true ;
' all-files is ls-filter

s" ." ls-r cr
