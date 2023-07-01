(de isPangram (Str)
   (not
      (diff
         '`(chop "abcdefghijklmnopqrstuvwxyz")
         (chop (lowc Str)) ) ) )
