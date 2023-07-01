/*REXX program  calculates and displays the   fusc   (or  Stern's Diatomic)   sequence. */
parse arg st # xw .                              /*obtain optional arguments from the CL*/
if st=='' | st==","  then st=  0                 /*Not specified?  Then use the default.*/
if  #=='' |  #==","  then  #= 61                 /* "      "         "   "   "     "    */
if xw=='' | xw==","  then xw=  0                 /* "      "         "   "   "     "    */
list= xw<1                                       /*boolean value:  LIST  to show numbers*/
@.=;        @.0= 0;       @.1= 1                 /*assign array default; assign low vals*/
mL= 0                                            /*the maximum length (digits)  so far. */
$=                                               /* "  list of  fusc  numbers    "  "   */
   do j=0  for #                                 /*process a bunch of integers from zero*/
   if j>1  then if j//2  then do;  _= (j-1) % 2;   p= (j+1) % 2;   @.j= @._ + @.p;   end
                         else do;  _= j % 2;                       @.j= @._;         end
   if list  then if j>=st  then $= $ commas(@.j)                      /*add it to a list*/
                           else nop                                   /*NOP≡placeholder.*/
            else do;   if length(@.j)<=mL  then iterate               /*still too small.*/
                       mL= length(@.j)                                /*found increase. */
                       if mL==1  then say '═══index═══   ═══fusc number═══'
                       say right( commas(j), 9)     right( commas(@.j), 14)
                       if mL==xw  then leave     /*Found max length?  Then stop looking.*/
                 end                             /* [↑]  display fusc #s of maximum len.*/
   end   /*j*/
                                                 /*$   has a superfluous leading blank. */
if $\==''  then say strip($)                     /*display a horizontal list of fusc #s.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:  parse arg ?;  do _=length(?)-3  to 1  by -3; ?=insert(',', ?, _); end;   return ?
