include FMS-SI.f

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
     del @ has-meth thing
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
