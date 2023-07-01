sub=.fork~new
sub~start('start_working')

Call syssleep 1
Do 3
  Say 'program   ' time()
  Call syssleep 1
  End

::class fork
:: method start_working
Do 6
  Say 'subroutine' time()
  Call syssleep 1
  End
