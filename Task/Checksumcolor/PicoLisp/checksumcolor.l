(in NIL
   (until (eof)
      (do 16
         (let C (pack (char) (char))
            (prin "^[[38;5;" (hex C) "m" C "^[[0m") ) )
      (prinl (line T)) ) )
