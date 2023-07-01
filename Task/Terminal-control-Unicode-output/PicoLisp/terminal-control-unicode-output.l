(if (sub? "UTF-8" (or (sys "LC_ALL") (sys "LC_CTYPE") (sys "LANG")))
   (prinl (char (hex "25b3")))
   (quit "UTF-8 capable terminal required") )
