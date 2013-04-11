/*REXX program to calculate the Levenshtein distance (between 2 strings)*/
call levenshtein 'kitten'                       , "sitting"
call levenshtein 'rosettacode'                  , "raisethysword"
call levenshtein 'Sunday'                       , "Saturday"
call levenshtein 'Vladimir_Levenshtein[1965]'   ,"Vladimir_Levenshtein[1965]"
call levenshtein 'this_algorithm_is_similar_to' ,"Damerau-Levenshtein_distance"
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────Levenshtein subroutine───────────*/
levenshtein: procedure; parse arg s,t;  m=length(s);  n=length(t);  d.=0
                        say '          1st string =' s
                        say '          2nd string =' t

                                    do i=1 for m;   d.i.0=i;   end   /*i*/
                                    do j=1 for n;   d.0.j=j;   end   /*j*/

  do     j=1 for n;   tj=substr(t,j,1);    jm=j-1
      do i=1 for m;   si=substr(s,i,1);    im=i-1
      if si==tj  then d.i.j = d.im.jm
                 else d.i.j = min(d.im.j,  d.i.jm,  d.im.jm)    + 1
      end   /*i*/
  end       /*j*/

say 'Levenshtein distance =' d.m.n;   say
return
