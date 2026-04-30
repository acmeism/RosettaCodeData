# The nested functions are subroutines
# These don't have parameters or return values
#
func$ makelist sep$ .
   counter = 1
   subr makeitem
      item$ = counter & sep$ & txt$ & "\n"
      counter += 1
   .
   txt$ = "first"
   makeitem
   r$ &= item$
   txt$ = "second"
   makeitem
   r$ &= item$
   txt$ = "third"
   makeitem
   r$ &= item$
   return r$
.
print makelist ". "
