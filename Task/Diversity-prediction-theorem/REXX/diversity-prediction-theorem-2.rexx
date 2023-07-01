/*REXX program calculates the  average error,  crowd error,  and  prediction diversity. */
                               numeric digits 50 /*use precision of fifty decimal digits*/
call diversity 49,   48  47  51                  /*true value and the crowd predictions.*/
call diversity 49,   48  47  51  42              /*  "    "    "   "    "        "      */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
avg:   $= 0;           do j=1  for #;  $= $ +  word(x, j)        ;   end;     return $ / #
avgSD: $= 0;  arg y;   do j=1  for #;  $= $ + (word(x, j) - y)**2;   end;     return $ / #
/*──────────────────────────────────────────────────────────────────────────────────────*/
diversity: parse arg true, x;    #= words(x);     a= avg()   /*get args; count #est; avg*/
           say '   the  true   value: '   true  copies("═", 20)  "crowd estimates: "   x
           say '   the average error: '   format( avgSD(true) , , 6) / 1
           say '   the  crowd  error: '   format( (true-a) **2, , 6) / 1
           say 'prediction diversity: '   format( avgSD(a)    , , 6) / 1;        say;  say
           return                                            /*   └─── show 6 dec. digs.*/
