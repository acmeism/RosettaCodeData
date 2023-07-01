sub=.fork~new
sub~sub
Call syssleep 1
Do 3
  Say 'program   ' time()
  Call syssleep 1
  End

::class fork
:: method sub
Reply
Do 6
  Say 'subroutine' time()
  Call syssleep 1
  End
