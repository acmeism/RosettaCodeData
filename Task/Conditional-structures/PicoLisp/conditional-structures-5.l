(case (expression)               # Evaluate the expression
   (value1                       # If it is equal to, or member of, 'value1'
      (do-this1)                 # Execute these expression(s)
      (do-that1) )
   (value2                       # Else if it is equal to, or member of, 'value2
      (do-this2)                 # Execute these expression(s)
      (do-that2) )
   (T                            # Else execute final expression(s)
      (do-something-else) ) )
