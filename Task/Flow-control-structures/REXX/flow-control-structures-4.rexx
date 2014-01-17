numeric digits 1000                 /*prepare for some gihugeic numbers.*/
...
n=4
say n'!='  factorial(n)
exit
/*──────────────────────────────────FACTORIAL subroutine────────────────*/
factorial: parse arg x
!=1
           do j=2  to x
           !=!*j
           end   /*j*/
return !
