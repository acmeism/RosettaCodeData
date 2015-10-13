include FMS-SI.f

-1 [if] \ add optional introspection facility to FMS

: fm' ( selector-ID link -- xt | 0 ) \ find method, linked-list search
  begin @ dup
  while 2dup cell+ @ =
  if [ 2 cells ] literal + nip @ exit then
  repeat 2drop false ;

: has-meth-L ( obj addr -- xt | 0 )
  swap >class over @ + fm' ;

: >xt' ( table-offset ^dispatch -- xt | 0 )
  2dup @ > if 2drop false exit then
  + @ ;

: has-meth-D ( obj addr -- xt | 0 )
  @ swap @ >xt' ;

: (has-meth) ( obj addr sel-type -- xt | 0 )
  seltype-L =
  if   ( obj addr ) has-meth-L
  else ( obj addr ) has-meth-D
  then ;

: [has-meth] ( obj "messageName" -- xt | 0 ) \ compile time only, can use ex-meth on xt to execute the method
  ' >body dup postpone literal cell+ @ postpone literal postpone (has-meth) ; immediate

: has-meth ( obj "messageName" -- xt | 0 ) \ interpret time only, can use ex-meth on xt to execute the method
  ' >body dup cell+ @ (has-meth) ;
[then]



:class delegate
  :m thing ." delegate implementation" ;m
;class

delegate slave

:class delegator
  ivar del  \ object container
  :m !: ( n -- ) del ! ;m
  :m init: 0 del ! ;m
  :m default ." default implementation" ;m
  :m operation
     del @ 0= if self default exit then
     del @ [has-meth] thing
     if del @ thing
     else self default
     then ;m
;class

delegator master

\ First, without a delegate
master operation \ => default implementation

\ then with a delegate that does not implement "thing"
object o
o master !:
master operation \ => default implementation

\ and last with a delegate that implements "thing"
slave master !:
master operation \ => delegate implementation
