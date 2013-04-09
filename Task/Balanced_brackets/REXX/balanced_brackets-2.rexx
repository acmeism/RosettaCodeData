/*REXX program to check for balanced brackets [] **********************
* test strings and random string generation copied from Version 1
* the rest restructured (shortened) to some extent
* and output made reproducible (random with a seed)
* 10.07.2012 Walter Pachl
**********************************************************************/
yesno.0 = 'unbalanced'
yesno.1 = '  balanced'
done.=0                           /* memory what's been done         */
n=0                               /* number of tests                 */
Call testbal '[][][][[]]'         /* first some user written tests   */
Call testbal '[][][][[]]]['
Call testbal '['
Call testbal ']'
Call testbal '[]'
Call testbal ']['
Call testbal '][]['
Call testbal '[[]]'
Call testbal '[[[[[[[]]]]]]]'
Call testbal '[[[[[]]]][]'
Call testbal '[][]'
Call testbal '[]][[]'
Call testbal ']]][[[[]'
Call testbal ']'
Call testbal '['
                                  /* then some random generated ones */
Call random 1,2,12345             /* call random with a seed         */
                                  /* makes test reproducible         */
do Until n=30                     /* up to 30 tests                  */
  s=rand(random(1,8))             /* a 01 etc. string of length 4-32 */
  q=translate(s,'[]',01)          /* turn digits into brackets       */
  if done.q then                  /* string was already here         */
    iterate                       /* don't test again                */
  call testbal q                  /* test balance                    */
  End
exit

testbal:                    /* test the given string and show result */
  n=n+1                           /* number of tests                 */
  Parse Arg q                     /* get string to be tested         */
  done.q=1                        /* mark as done                    */
  call checkBal q                 /* test balance                    */
  lq=format(length(q),2)
  say right(n,2) lq yesno.result q/* show result and string          */
  Return

/*-----------------------------------PAND subroutine-----------------*/
pand: p=random(0,1);    return p || \p
/*-----------------------------------RAND subroutine-----------------*/
rand: pp=pand();   pp=pand()pp;    pp=copies(pp,arg(1))
      i=random(2,length(pp));      pp=left(pp,i-1)substr(pp,i)
return pp

checkBal: procedure               /*check for balanced brackets ()   */
  Parse arg y
  nest=0;
  do While y<>''
    Parse Var y c +1 y            /*pick off one character at a time */
    if c='[' then                 /* opening bracket                 */
      nest=nest+1                 /* increment nesting               */
    else do                       /* closing bracket                 */
      if nest=0 then              /* not allowed                     */
        return 0;                 /* no success                      */
      nest=nest-1                 /* decrement nesting               */
      end
    end
  return nest=0                   /* nest=0 -> balanced              */
