(when (condition)                # If the condition evaluates to non-NIL
   (then-do-this)                # Then execute tall following expressions
   (and-more) )

(unless (condition)              # If the condition evaluates to NIL
   (then-do-this)                # Then execute all following expressions
   (and-more) )
