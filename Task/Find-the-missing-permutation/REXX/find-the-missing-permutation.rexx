/*REXX program finds (a)  missing permutation(s)  from an internal list.*/
list = 'ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA',
       'CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB'
@.=                                    /* [↓]  needs to be THINGS long. */
@abcU  = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'  /*an uppercase (Latin) alphabet. */
things = 4                             /*# of unique letters to be used.*/
bunch  = 4                             /*# letters to be used at a time.*/
                 do j=1  for things
                 $.j=substr(@abcU,j,1)
                 end   /*j*/           /* [↑]  construct a letter array.*/
call permset 1                         /*invoke  PERMSET  (recursively).*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────PERMSET subroutine──────────────────*/
permset: procedure expose $. @. bunch list things;   parse arg ?
if ?>bunch  then do
                 _=;         do m=1  for bunch       /*build permutation*/
                             _=_ || @.m              /*add perm ──► list*/
                             end   /*m*/
                                                     /* [↓]  is in list?*/
                 if wordpos(_,list)==0  then say _ ' is missing from the list.'
                 end
            else do x=1  for things                  /*build a new perm.*/

                             do k=1  for ?-1
                             if @.k==$.x  then iterate x   /*been built?*/
                             end  /*k*/
                 @.?=$.x                             /*define as built. */
                 call permset ?+1                    /*call recursively.*/
                 end   /*x*/
return
