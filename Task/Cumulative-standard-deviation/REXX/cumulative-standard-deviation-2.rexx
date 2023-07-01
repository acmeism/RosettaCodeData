/*REXX program calculates and displays the standard deviation of a given set of numbers.*/
parse arg #                                      /*obtain optional arguments from the CL*/
if #=''  then  #= 2 4 4 4 5 5 7 9                /*None specified?  Then use the default*/
n= words(#);                       $= 0;   $$= 0 /*N:  # items; $,$$:  sums to be zeroed*/
                                                 /* [↓]  process each number in the list*/
           do j=1  for n                         /*perform summation on two sets of #'s.*/
           _= word(#, j);         $= $   +  _
                                 $$= $$  +  _**2
           end   /*j*/
say 'standard deviation: ' sqrt($$/n - ($/n)**2) /*calculate&display the std, deviation.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x; if x=0  then return 0; d=digits(); h=d+6; m.=9; numeric form
      numeric digits; parse value format(x,2,1,,0) 'E0' with g 'E' _ .;   g=g * .5'e'_ % 2
                   do j=0  while h>9;      m.j=h;               h=h%2+1;        end  /*j*/
                   do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g)*.5;   end  /*k*/
      numeric digits d;                    return g/1
