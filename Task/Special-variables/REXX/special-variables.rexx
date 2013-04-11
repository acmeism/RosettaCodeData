/*REXX program to demonstrate REXX special variables: RC, RESULT, SIGL. */
                           /*line two.  */
                           /*line three.*/             say copies('=',75)
rc=1/3                     /*line four. */
signal youWho              /*line five. */
myLoo='this got skipped'   /*line six.  */
youwho:                    /*line seven.*/
say 'SIGL=' sigl
say 'REXX source statement' SIGL '=' sourceline(sigl)
                                                       say copies('=',75)
g=44
call someFunc g
say 'rc=' rc
say 'result=' result
                                                       say copies('=',75)
h=66
hh=someFunc(h)
say 'rc=' rc
say 'result=' result
say 'hh=' hh
                                                       say copies('=',75)
'DIR C:\ /ad   |   find /i /v "Volume " '
say 'rc=' rc
say 'result=' result
                                                       say copies('=',75)
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────────someFunc subroutine.───────────────*/
someFunc: procedure;   parse arg x;     return x/2
