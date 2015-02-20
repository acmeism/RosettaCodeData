/*REXX program to draw a cuboid  (dimensions must be positive integers).*/
parse arg x y z indent .               /*x,y,z  dimensions, indentation.*/
x=p(x 1);     y=p(y x);     z=p(z y);     indent=p(indent 0)

                   call sayer   y+2  ,       ,    "+-"
  do j=1 for y;    call sayer   y-j+2,    j-1,    "/ |"    ;     end
                   call sayer        ,    y  ,    "+-|"
  do z-1;          call sayer        ,    y  ,    "| |"    ;     end
                   call sayer        ,    y  ,    "| +"
  do j=1 for y;    call sayer        ,    y-j,    "| /"    ;     end
                   call sayer        ,       ,    "+-"

exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────P subroutine────────────────────────*/
p:  return word(arg(1),1)              /*pick the first word in the list*/
/*──────────────────────────────────SAYER subroutine────────────────────*/
sayer:  parse arg times,a,_            /*get the arguments specified.   */
say left('',indent)right(left(_,1),pick1(times 1)) || ,
       copies(substr(_,2,1),4*x)left(_,1)right(substr(_,3,1),pick1(a 0)+1)
return
