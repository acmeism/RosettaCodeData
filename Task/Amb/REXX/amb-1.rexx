/*REXX program demonstrates Amd operator, choosing a word from each set.*/
@.=                                    /*default value for any # of sets*/
@.1 = "the that a"
@.2 = "frog elephant thing"
@.3 = "walked treaded grows"
@.4 = "slowly quickly"
   do j=1 until @.j==''; end;  @.0=j-1 /*set  @.0 to the number of sets.*/
call Amb 1                             /*find combo of words that works.*/
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────AMB procedure────────────────────*/
Amb:  procedure expose @.;  parse arg # _;  arg . u;  if #=='' then return
if #>@.0 then do; if u=='' then return /*return if no words are left.   */
              w=word(u,1)              /*use upper case version of word.*/
                             do n=2  to words(u);    c=word(u,n)
                             if left(c,1)\==right(w,1)  then return;   w=c
                             end   /*n*/
              say strip(_)             /* _ has an extra leading blank. */
              end
        do k=1  for words(@.#)
        call amb  #+1  _  word(@.#,k)  /*generate the next combination. */
        end   /*k*/
return
