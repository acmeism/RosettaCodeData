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
say 'result:';       say rootI(num, root, digs)  /*   "    what it is; display the root.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
rootI: procedure; parse arg x,root,p             /*obtain the numbers,  Y is the root #.*/
       numeric digits p*root+length(x)           /*double the number of digits  + guard.*/
       if x<2  then return x                     /*B is one or zero?  Return that value.*/
       z=x*(10**root)**p                         /*calculate the number with appended 0s*/
       m=root - 1                                /*utilize a diminished (by one) power. */
       g=(1 + z) % root                          /*take a stab at the first root guess. */
       old=.                                     /* [↓]  When M=1, a fast path for sqrt.*/
       if m==1  then  do  until old==g;   old=g;     g=(g   + z %  g     )  % root;    end
                else  do  until old==g;   old=g;     g=(g*m + z % (g**m) )  % root;    end
       return left(g,p)                          /*return the  Nth root of Z to invoker.*/
