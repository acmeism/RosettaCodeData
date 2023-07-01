/*REXX pgm computes the Padovan seq. (using 2 methods), and also computes the L─strings.*/
numeric digits 40                                /*better precision for Plastic ratio.  */
parse arg n nF Ln cL .                           /*obtain optional arguments from the CL*/
if  n=='' |  n==","  then  n= 20                 /*Not specified?  Then use the default.*/
if nF=='' | nF==","  then nF= 64                 /* "      "         "   "   "     "    */
if Ln=='' | Ln==","  then Ln= 10                 /* "      "         "   "   "     "    */
if cL=='' | cL==","  then cL= 32                 /* "      "         "   "   "     "    */
PR= 1.324717957244746025960908854                /*the plastic ratio  (constant).       */
 s= 1.0453567932525329623                        /*tge  "s"  constant.                  */
    @.= .;      @.0= 1;      @.1= 1;      @.2= 1 /*initialize 3 terms of the Padovan seq*/
    !.= .;      !.0= 1;      !.1= 1;      !.2= 1 /*     "     "   "    "  "     "     " */
call req1;   call req2;   call req3;   call req4 /*invoke the four task's requirements. */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
floor: procedure; parse arg x;      t= trunc(x);               return t  -  (x<0) * (x\=t)
pF:    procedure expose !. PR s; parse arg x;  !.x= floor(PR**(x-1)/s + .5);    return !.x
th:    parse arg th; return th||word('th st nd rd',1+(th//10)*(th//100%10\==1)*(th//10<4))
/*──────────────────────────────────────────────────────────────────────────────────────*/
L_sys: procedure: arg x; q=; a.A= 'B'; a.B= 'C'; a.C= 'AB';      if x==''  then return 'A'
                                do k=1  for length(x);  _= substr(x, k, 1);  q= q  ||  a._
                                end   /*k*/;                           return q
/*──────────────────────────────────────────────────────────────────────────────────────*/
p:     procedure expose @.; parse arg x;  if @.x\==.  then return @.x     /*@.X defined?*/
       xm2= x - 2;    xm3= x - 3;    @.x= @.xm2 + @.xm3;   return @.x
/*──────────────────────────────────────────────────────────────────────────────────────*/
req1:                   say 'The first '    n    " terms of the Pandovan sequence:";
       $= @.0;  do j=1  for n-1;   $= $  p(j)
                end   /*j*/
       say $;                                                          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
req2:  ok= 1;           what= ' terms match for  recurrence  and  floor─based  functions.'
                do j=0  for nF;  if p(j)==pF(j)  then iterate
                say 'the '   th(j)   " terms don't match:"   p(j)  pF(j);   ok= 0
                end   /*j*/
       say
       if ok  then say 'all '    nF    what;                           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
req3:                               y=;             $= 'A'
                do j=1  for Ln-1;   y= L_sys(y);    $= $  L_sys(y)
                end   /*j*/
       say
       say 'L_sys:'  $;                                                return
/*──────────────────────────────────────────────────────────────────────────────────────*/
req4:  y=;              what=' terms match for Padovan terms and lengths of L_sys terms.'
       ok= 1;   do j=1  for cL;  y= L_sys(y);   L= length(y)
       if       L==p(j-1)  then iterate
                say 'the '    th(j)    " Padovan term doesn't match the length of the",
                                       'L_sys term:'   p(j-1)  L;           ok= 0
                end   /*j*/
       say
       if ok  then say 'all '    cL    what;                           return
