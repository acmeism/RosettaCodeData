/*REXX program reports on the time  4  different tasks take (wall clock)*/
time.=                                 /*nullify times for all tasks.   */
/*──────────────────────────────────────────────────────────────────────*/
call time 'Reset'                      /*reset the REXX (elapsed) timer.*/
                                       /*show   π   in hexadecimal to   */
                                       /*2,000 decimal places.          */
                  task.1='base(pi,16)'
                  call '$CALC' task.1  /*perform task number one.       */
time.1=time('Elapsed')                 /*save the time used by task 1.  */
/*──────────────────────────────────────────────────────────────────────*/
call time 'Reset'                      /*reset the REXX (elapsed) timer.*/
                                       /*get primes # 40000──►40800 and */
                                       /*show their differences.        */
                  task.2='diffs[prime(40k,40.8k)] ;;; group 20'
                  call '$CALC' task.2  /*perform task number two.       */
time.2=time('Elapsed')                 /*save the time used by task 2.  */
/*──────────────────────────────────────────────────────────────────────*/
call time 'Reset'                      /*reset the REXX (elapsed) timer.*/
                                       /*show the Collatz sequence for  */
                                       /*a stupidly big number.         */
                  task.3='collatz(38**8) ;;; Horizontal'
                  call '$CALC' task.3  /*perform task number three.     */
time.3=time('Elapsed')                 /*save the time used by task 3.  */
/*──────────────────────────────────────────────────────────────────────*/
call time 'Reset'                      /*reset the REXX (elapsed) timer.*/
                                       /*plot SIN in ½ degree increments*/
                                       /*using 9 decimal digits  (¬ 60).*/
                  task.4='sind(-180,+180,0.5) ;;; Plot DIGits 9'
                  call '$CALC' task.4  /*perform task number four.      */
time.4=time('Elapsed')                 /*save the time used by task 4.  */
/*──────────────────────────────────────────────────────────────────────*/
say
    do j=1  while time.j\==''
    say 'time used for task' j "was" right(format(time.j,,0),4) 'seconds.'
    end   /*j*/
                                       /*stick a fork in it, we're done.*/
