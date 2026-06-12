/*REXX program finds & displays the Nth Ulam number (or any number of specified values).*/
parse arg $                                      /*obtain optional argument from the CL.*/
if $='' | $=","  then $= 10 100 1000 10000       /*Not specified? Then use the defaults.*/

        do k=1  for words($)                     /*process each of the specified values.*/
        x= Ulam( word($, k) )                    /*invoke Ulam to find a  Ulam  number. */
        say 'the '        commas(#)th(#)       ' Ulam number is: '           commas(x)
        end   /*k*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg _;  do jc=length(_)-3  to 1  by -3; _= insert(',', _, jc); end; return _
th:     parse arg th; return word('th st nd rd', 1 + (th//10)*(th//100%10\==1)*(th//10<4))
/*──────────────────────────────────────────────────────────────────────────────────────*/
Ulam: parse arg n;    @.1= 1;   @.2= 2;   #= 2   /*1st two terms;  #:  sequence length. */
                      !.= 0;    !.1= 1;   !.2= 1 /*semaphore for each term in sequence. */
      z= 3                                       /*value of next possible term in seq.  */
                 do until #==n
                 cnt= 0
                        do j=1  for #;        _= z - @.j    /*_:   short circuit value. */
                        if !._  then if @.j\==_  then do;   cnt= cnt + 1
                                                            if cnt>2  then leave
                                                      end
                        end   /*j*/

                 if cnt==2  then do;  #= # + 1              /*bump the number of terms. */
                                      @.#= z                /*add  Z  to the sequence.  */
                                      !.z= 1                /*set the semaphore for  Z. */
                                 end
                 z= z + 1                                   /*bump next possible term.  */
                 end   /*until*/
      return @.#
