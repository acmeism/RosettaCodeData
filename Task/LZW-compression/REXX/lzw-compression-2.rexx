/*REXX program compresses text using the  LZW  (Lempel─Ziv─Welch), and reconstitutes it.*/
parse arg x                                      /*get an optional argument from the CL.*/
if x=''  then x= '"There is nothing permanent except change." ─── Heraclitus [540-475 BC]'
       say 'original text='        x
cypher=LZWc(x)                                   /*compress text using the LZW algorithm*/
       say 'reconstituted='   LZWd(cypher)
       say ' LZW integers='        cypher
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
LZWc: procedure; parse arg y,,w $ @.;  #=256             /*the  LZW  compress algorithm.*/
                           do j=0  for #;   _=d2c(j);      @._=j;        end  /*j*/

                           do k=1  for length(y);            _=w || substr(y, k, 1)
                           if @._==''  then do;  $=$ @.w;  @._=#;  #=#+1;  w=substr(y,k,1)
                                            end
                                       else w=_
                           end   /*k*/
      return strip($ @.w)                                /*remove any superfluous blanks*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
LZWd: procedure; parse arg w y,,@.;    #=256             /*the LZW decompress algorithm.*/
                           do j=0  for #;          @.j=d2c(j);    end  /*j*/
      $=@.w;   w=$
                           do k=1  for words(y);            _=word(y, k)
                           if @._\=='' | @.k==" "  then ?=@._
                                                   else  if _==#  then ?=w || left(w, 1)
                           $=$ || ?
                           @.#=w || left(?, 1);    #=#+1;         w=?
                           end   /*k*/
      return $
