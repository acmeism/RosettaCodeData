/*REXX program calculates  N  terms of the fairshare sequence for some group of peoples.*/
parse arg n g                                    /*obtain optional arguments from the CL*/
if n=='' | n==","  then n= 25                    /*Not specified?  Then use the default.*/
if g=''  | g=","   then g=  2 3 5 11             /* "      "         "   "   "     "    */
                                                 /* [↑]  a list of a number of peoples. */
     do p=1  for words(g);        r= word(g, p)  /*traipse through the bases specfiied. */
     $= 'base' right(r, 2)': '                   /*construct start of the 1─line output.*/
        do j=0  for n;   $= $ right( sumDigs( base(j, r))  //  r, 2)','
        end   /*j*/                              /* [↑] append # (base R) mod R──►$ list*/
     say strip($, , ",")                         /*elide trailing comma from the $ list.*/
     end      /*p*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
base: parse arg #,b,,y;          @= 0123456789abcdefghijklmnopqrstuvwxyz;  @@= substr(@,2)
        do while #>=b; y= substr(@, #//b + 1, 1)y; #= #%b; end;  return substr(@, #+1, 1)y
/*──────────────────────────────────────────────────────────────────────────────────────*/
sumDigs: parse arg x; !=0; do i=1 for length(x); != !+pos(substr(x,i,1),@@); end; return !
