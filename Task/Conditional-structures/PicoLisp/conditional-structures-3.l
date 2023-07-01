(if2 (condition1) (condition2)   # If both conditions evaluate to non-NIL
   (expression-both)             # Then execute this expression
   (expression-first)            # Otherwise this for the first
   (expression-second)           # or this the second condition.
   (expression-none)             # If both are NIL, all following expressions
   (and-more) )
