/*REXX program computes and displays the root mean square of a number sequence*/
parse arg n .                          /*obtain the optional argument from CL.*/
if n==''  then n=10                    /*Not specified?  Then use the default.*/
numeric digits 50                      /*go a little overboard on decimal digs*/
sum=0                                  /*the sum of numbers squared  (so far).*/
                   do j=1  for n       /*process each of the   N   integers.  */
                   sum=sum+j**2        /*sum the   squares   of the integers. */
                   end   /*j*/
rms=sqrt(sum/n)                        /*divide by N, then calculate the SQRT.*/
say 'root mean square for 1──►'n  "is"  rms                /*display the RMS. */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
sqrt:  procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
       numeric digits 9; numeric form; h=d+6;  if x<0  then do; x=-x; i='i'; end
       parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
          do j=0  while h>9;      m.j=h;              h=h%2+1;        end  /*j*/
          do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;   end  /*k*/
       numeric digits d;     return (g/1)i            /*make complex if X < 0.*/
