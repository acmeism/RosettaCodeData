/*REXX pgm calculates/displays the Levenshtein distance between 2 text strings*/
call Levenshtein  'kitten'                      , "sitting"
call Levenshtein  'rosettacode'                 , "raisethysword"
call Levenshtein  'Sunday'                      , "Saturday"
call Levenshtein  'Vladimir Levenshtein[1965]'  , "Vladimir Levenshtein[1965]"
call Levenshtein  'this algorithm is similar to', "Damerau─Levenshtein distance"
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
Levenshtein: procedure; parse arg o,t;  oL= length(o);   tL= length(t);    @.= 0
say '     original string  = '    o                        /*display string 1.*/
say '       target string  = '      t                      /*   "       "   2.*/
                 do #=1  for tL;  @.0.#= #;  end  /*#*/    /*the   drop  array*/
                 do #=1  for oL;  @.#.0= #;  end  /*#*/    /* "   insert   "  */
    do    j=1  for tL;    j_= j-1;   q= substr(t, j, 1)    /*obtain character.*/
       do k=1  for oL;    k_= k-1
       if q==substr(o, k, 1)  then @.k.j= @.k_.j_          /*use previous char*/
                              else @.k.j= 1   +   min(@.k_.j,  @.k.j_,  @.k_.j_)
        end   /*k*/
    end       /*j*/                               /* [↑]  use the best choice.*/
say 'Levenshtein distance  = '     @.oL.tL;          say;               return
