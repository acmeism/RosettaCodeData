/*REXX program outputs its own source including comments and blank lines.*/
      do k=1 for sourceline()
      say sourceline(k)
      end   /*k*/
