/*REXX pgm shows different scopes of a variable: "global"  and  "local".*/
q = 55          ;    say ' 1st q='  q  /*assign a value ───►  "main"  Q.*/
call sub        ;    say ' 2nd q='  q  /*call a procedure subroutine.   */
call gyro       ;    say ' 3rd q='  q  /*call a procedure with EXPOSE.  */
call sand       ;    say ' 4th q='  q  /*call a subroutine or function. */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SUB subroutine──────────────────────*/
sub:  procedure                        /*use PROCEDURE to use local vars*/
q = -777        ;    say ' sub q='  q  /*assign a value ───► "local" Q. */
return
/*──────────────────────────────────GYRO subroutine─────────────────────*/
gyro: procedure expose q               /*use EXPOSE to use global var Q.*/
q = "yuppers"   ;    say 'gyro q='  q  /*assign a value ───► "exposed" Q*/
return
/*──────────────────────────────────SAND subroutine─────────────────────*/
sand:                                  /*all REXX variables are exposed.*/
q = "Monty"     ;    say 'sand q='  q  /*assign a value ───► "global"  Q*/
return
