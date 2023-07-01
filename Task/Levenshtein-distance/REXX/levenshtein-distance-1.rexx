/*REXX program  calculates and displays the  Levenshtein distance  between two strings. */
call Levenshtein   'kitten'                        ,     "sitting"
call Levenshtein   'rosettacode'                   ,     "raisethysword"
call Levenshtein   'Sunday'                        ,     "Saturday"
call Levenshtein   'Vladimir Levenshtein[1965]'    ,     "Vladimir Levenshtein[1965]"
call Levenshtein   'this algorithm is similar to'  ,     "Damerau─Levenshtein distance"
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Levenshtein: procedure; parse arg o,t;  oL= length(o);   tL= length(t);     @.= 0
    say '        original string  = '    o                          /*show   old  string*/
    say '          target string  = '    t                          /*  "   target   "  */
                     do #=1  for tL;   @.0.#= #;   end  /*#*/       /*the   drop  array.*/
                     do #=1  for oL;   @.#.0= #;   end  /*#*/       /* "   insert   "   */
         do    j=1  for tL;   jm= j-1;    q= substr(t, j, 1)        /*obtain character. */
            do k=1  for oL;   km= k-1
            if q==substr(o, k, 1)  then @.k.j= @.km.jm              /*use previous char.*/
                                   else @.k.j= 1   +   min(@.km.j,  @.k.jm,  @.km.jm)
            end   /*k*/
         end      /*j*/                                             /* [↑]  best choice.*/
    say '   Levenshtein distance  = '  @.oL.tL;    say;      return
