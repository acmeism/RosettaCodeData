/*REXX program finds one or more  missing permutations  from an internal list.*/
          list = 'ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA',
                 'CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB'
@.=                                    /* [↓]  needs to be as long as  THINGS.*/
@abcU  = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'  /*an uppercase (Latin/Roman) alphabet. */
things = 4                             /*number of unique letters to be used. */
bunch  = 4                             /*number letters to be used at a time. */
                 do j=1  for things    /* [↓]  only get a portion of alphabet.*/
                 $.j=substr(@abcU,j,1) /*extract just one letter from alphabet*/
                 end   /*j*/           /* [↑]  build a letter array for speed.*/
call permSet 1                         /*invoke  PERMSET  sub. (recursively). */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
permSet: procedure expose $. @. bunch list things;    parse arg ?
if ?>bunch  then do
                 _=;      do m=1  for bunch           /*build a permutation.  */
                          _=_ || @.m                  /*add permutation──►list*/
                          end   /*m*/
                                                      /* [↓]  is in the list? */
                 if wordpos(_,list)==0  then say _  ' is missing from the list.'
                 end
            else do x=1  for things                   /*build a permutation.  */
                          do k=1  for ?-1
                          if @.k==$.x then iterate x  /*was permutation built?*/
                          end  /*k*/
                 @.?=$.x                              /*define as being built.*/
                 call permSet  ?+1                    /*call subr. recursively*/
                 end   /*x*/
return
