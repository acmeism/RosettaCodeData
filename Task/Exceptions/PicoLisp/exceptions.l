(catch 'thisLabel          # Catch this label
   (println 1)             # Do some processing (print '1')
   (throw 'thisLabel 2)    # Abort processing and return '2'
   (println 3) )           # This is never reached
