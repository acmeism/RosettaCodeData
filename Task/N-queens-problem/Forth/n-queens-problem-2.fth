\ http://www.forth.org/fd/FD-V02N1.pdf
VOCABULARY nqueens ALSO nqueens DEFINITIONS

8 constant queens

\ Nqueen solution from FD-V02N1.pdf
: 1array CREATE 0 DO 1 , LOOP DOES> SWAP CELLS + ;
    queens 1array a \ a,b & c: workspaces for solutions
 queens 2* 1array b
 queens 2* 1array c
    queens 1array x \ trial solutions

: safe ( c i -- n )
  SWAP
  2DUP - queens 1- + c @ >R
  2DUP + b @ >R
  DROP a @ R> R> * * ;

: mark ( c i -- )
  SWAP
  2DUP - queens 1- + c 0 swap !
  2DUP + b 0 swap !
  DROP a 0 swap ! ;

: unmark ( c i -- )
  SWAP
  2DUP - queens 1- + c 1 swap !
  2DUP + b 1 swap !
  DROP a 1 swap ! ;

VARIABLE tries
VARIABLE sols

: .cols queens 0 DO I x @ 1+ 5 .r loop ;
: .sol ." Found on try " tries @ 6 .R .cols cr ;

: try
  queens 0
  DO 1 tries +!
     DUP I safe
     IF DUP I mark
	DUP I SWAP x !
	DUP queens 1- < IF DUP 1+ RECURSE ELSE sols ++ .sol THEN
	DUP I unmark
     THEN
  LOOP DROP ;

: go 0 tries ! CR 0 try CR sols @ . ." solutions Found, for n = " queens . ;
go
