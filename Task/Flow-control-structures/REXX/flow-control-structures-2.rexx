numeric digits 1000                 /*prepare for some gihugeic numbers.*/
...
n=4
call factorial n
say n'!=' result
exit
/*──────────────────────────────────FACTORIAL subroutine────────────────*/
factorial: parse arg x
!=1
           do j=2  to x
           !=!*j
           end   /*j*/
return !
