(let (Str "Here am I"  Len (format (opt)))  # Get length from command line
   (unless (>= (size Str) Len)              # Check buffer size
      (prinl Str) ) )                       # Return string if OK
