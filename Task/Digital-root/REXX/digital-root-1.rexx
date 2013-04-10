/* REXX ***************************************************************
* Test digroot
**********************************************************************/
                                                 /*           n r p */
say right(7           ,12) digroot(7           ) /*           7 7 0 */
say right(627615      ,12) digroot(627615      ) /*      627615 9 2 */
say right(39390       ,12) digroot(39390       ) /*       39390 6 2 */
say right(588225      ,12) digroot(588225      ) /*      588225 3 2 */
say right(393900588225,12) digroot(393900588225) /*393900588225 9 2 */
  Exit
digroot: Procedure
/**********************************************************************
* Compute the digital root and persistence of the given decimal number
* 25.07.2012 Walter Pachl
**************************** Bottom of Data **************************/
Parse Arg n                         /* the number                    */
p=0                                 /* persistence                   */
Do While length(n)>1                /* more than one digit in n      */
  s=0                               /* initialize sum                */
  p=p+1                             /* increment persistence         */
  Do while n<>''                    /* as long as there are digits   */
    Parse Var n c +1 n              /* pick the first one            */
    s=s+c                           /* add to the new sum            */
    End
  n=s                               /* the 'new' number              */
  End
return n p                          /* return root and persistence   */
