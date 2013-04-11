/*REXX program to illustrate  DO  loop with an  ITERATE  (continue). */

    do j=1 to 10
    call charout ,  j", "

    if j//5==0 then do
                    say
                    iterate
                    end
    end   /*j*/
