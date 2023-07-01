\ make starting position for Chess960, constructive

\             0    1    2    3    4    5    6    7    8    9
create krn S" NNRKRNRNKRNRKNRNRKRNRNNKRRNKNRRNKRNRKNNRRKNRNRKRNN" mem,

create pieces 8 allot

: chess960 ( n -- )
  pieces 8 erase
  4 /mod swap  2* 1+ pieces + 'B swap c!
  4 /mod swap  2*    pieces + 'B swap c!
  6 /mod swap  pieces swap bounds begin dup c@ if swap 1+ swap then 2dup > while 1+ repeat drop 'Q swap c!
  5 * krn +  pieces 8 bounds do i c@ 0= if dup c@ i c! 1+ then loop drop
  cr pieces 8 type ;

0   chess960   \ BBQNNRKR ok
518 chess960   \ RNBQKBNR ok
959 chess960   \ RKRNNQBB ok

960 choose chess960    \ random position
