/*REXX program obtains/displays Catalan numbers from  Pascal's triangle.*/
parse arg N .;   if N==''  then N=15   /*Any args?  No, then use default*/
numeric digits max(9,N%2+N%8)          /*can handle huge Catalan numbers*/
@.=0;   @.1=1                          /*stem array default;  1st value.*/

  do i=1  for N;   ip=i+1
                 do j=i   by -1  for N;  @.j=@.j+@(j-1);   end  /*j*/
  @.ip=@.i;      do k=ip  by -1  for N;  @.k=@.k+@(k-1);   end  /*k*/
  say  @.ip-@.i                        /*display the Ith Catalan number.*/
  end   /*i*/

exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────@ subroutine────────────────────────*/
@:  parse arg !;  return @.!           /*return the value of  @.[arg(1)]*/
