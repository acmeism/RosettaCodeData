/*REXX program calculates the Nth root of a number to a specified number of decimal digs*/
parse arg num root digs .                        /*obtain the optional arguments from CL*/
if  num=='' |  num==","  then  num=   2          /*Not specified?  Then use the default.*/
if root=='' | root==","  then root=   2          /* "      "         "   "   "     "    */
if digs=='' | digs==","  then digs=2001          /* "      "         "   "   "     "    */
numeric digits digs                              /*utilize this number of decimal digits*/
say 'number='  num                               /*display the number that will be used.*/
say '  root='  root                              /*   "     "    root   "    "   "   "  */
say 'digits='  digs                              /*   "    dec. digits  "    "   "   "  */
say                                              /*   "    a blank line.                */
say 'result:';           say iRoot(num, root)    /*   "    what it is; display the root.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
iRoot: procedure; parse arg x 1 ox,    y 1 oy    /*obtain the numbers,  Y is the root #.*/
i=;                         x=abs(x);  y=abs(y)  /*use the absolute values of  X and Y. */
if ox<0 & oy//2==0  then do;  i='i';  ox=x;  end /*if the results will be imaginary ··· */
od=digits()                                      /*the current number of decimal digits.*/
a=od+9                                           /*bump the decimal digits by  nine.    */
numeric form                                     /*number will be in  exponential  form.*/
parse value format(x,2,1,,0) 'E0' with ? 'E' _ . /*obtain exponent so we can do division*/
g=(?/y'E'_ % y)  +  (x>1)                        /*this is a best first guess of a root.*/
m=y-1                                            /*define a (fast) variable for later.  */
d=5                                              /*start with only five decimal digits. */
             do  until d==a                      /*keep computing 'til we're at max digs*/
             d=min(d+d,a);           dm=d-2      /*bump number of (growing) decimal digs*/
             numeric digits d                    /*increase the number of decimal digits*/
             o=0                                 /*set the old value to zero (1st time).*/
                 do  until o=g;      o=g         /*keep computing as long as  G changes.*/
                 g=format((m*g**y+x)/y/g**m,,dm) /*compute the  Yth  root of  X.        */
                 end   /*until o=g*/
             end       /*until d==a*/
_=g*sign(ox)                                     /*change the sign of the result, maybe.*/
numeric digits od                                /*set  numeric digits  to the original.*/
if oy<0  then return (1/_)i                      /*Is the root negative?  Use reciprocal*/
              return (_/1)i                      /*return the  Yth root of X to invoker.*/
