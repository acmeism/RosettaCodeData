/*REXX program  obtains and displays  Catalan numbers  from  a  Pascal's triangle.      */
parse arg N .                                    /*Obtain the optional argument from CL.*/
if N=='' | N==","  then N=15                     /*Not specified?  Then use the default.*/
numeric digits max(9, N%2 + N%8)                 /*so we can handle huge Catalan numbers*/
@.=0;   @.1=1                                    /*stem array default; define 1st value.*/

  do i=1  for N;                               ip=i+1
                      do j=i   by -1  for N;   jm=j-1;   @.j=@.j+@.jm;    end /*j*/
  @.ip=@.i;           do k=ip  by -1  for N;   km=k-1;   @.k=@.k+@.km;    end /*k*/
  say  @.ip - @.i                                /*display the   Ith   Catalan number.  */
  end   /*i*/                                    /*stick a fork in it,  we're all done. */
