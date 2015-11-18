/*REXX program calculates the  Levenshtein distance  between two text strings.*/
call Levenshtein  'kitten'                      , "sitting"
call Levenshtein  'rosettacode'                 , "raisethysword"
call Levenshtein  'Sunday'                      , "Saturday"
call Levenshtein  'Vladimir_Levenshtein[1965]'  , "Vladimir_Levenshtein[1965]"
call Levenshtein  'this_algorithm_is_similar_to', "Damerau-Levenshtein_distance"
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
Levenshtein: procedure; parse arg s,t;     sL=length(s);      tL=length(t)
say '          1st string  = '    s
say '          2nd string  = '      t
@.=0;                                         do i=1  for tL; @.0.i=i; end /*i*/
                                              do i=1  for sL; @.i.0=i; end /*i*/
  do     j=1  for tL; j_=j-1; q=substr(t,j,1)
      do k=1  for sL; k_=k-1
      if q==substr(s,k,1)  then @.k.j=@.k_.j_
                           else @.k.j=1   +   min(@.k_.j,  @.k.j_,  @.k_.j_)
      end   /*k*/
  end       /*j*/

say 'Levenshtein distance  = '  @.sL.tL;                 say
return
