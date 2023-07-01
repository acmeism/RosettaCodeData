(unless (>= (version T) (3 0 1))       # Check version (only in the 64-bit version)
   (bye) )

# (setq bloop -7)                      # Uncomment this to get the output '7'

(and
   (num? bloop)                        # When 'bloop' is bound to a number
   (getd 'abs)                         # and 'abs' defined as a function
   (println (abs bloop)) )             # then print the absolute value
