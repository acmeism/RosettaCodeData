(cond
   ((condition1)                 # If this condition evaluates to non-NIL
      (expression 1)             # Execute these expression(s)
      (more 1) )
   ((condition2)                 # Otherwise, if this evaluates to non-NIL
      (expression 2)             # Execute these expression(s)
      (more 2) )
   (T                            # If none evaluated to non-NIL
      (expression 1)             # Execute these expression(s)
      (more 1) )

(nond
   ((condition1)                 # If this condition evaluates to NIL
      (expression 1)             # Execute these expression(s)
      (more 1) )
   ((condition2)                 # Otherwise, if this evaluates to NIL
      (expression 2)             # Execute these expression(s)
      (more 2) )
   (NIL                          # If none evaluated to NIL
      (expression 1)             # Execute these expression(s)
      (more 1) )
