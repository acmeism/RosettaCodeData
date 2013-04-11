/*REXX program finds a  missing permuation  from an internal list.      */

list='ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA',
     'CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB'

@.=;   @abcU='ABCDEFGUIJKLMNOPQRSTUVWXYZ'
things=4
bunch=4
                 do j=1 for things     /*build list of permutation obj. */
                 $.j=substr(@abcu,j,1)
                 end   /*j*/
call permset 1
exit
/*─────────────────────────────────────PERMSET subroutine───────────────*/
permset:procedure expose $. @. bunch list things;   parse arg ?
if ?>bunch then do;   _=@.1;         do m=2 to bunch
                                     _=_||@.m
                                     end   /*m*/
                if wordpos(_,list)==0 then say _ ' is missing from the list.'
                end
           else do x=1 for things      /*construction a new permuation. */
                  do k=1 for ?-1;  if @.k==$.x then iterate x;  end  /*k*/
                @.?=$.x
                call permset ?+1
                end   /*x*/
return
