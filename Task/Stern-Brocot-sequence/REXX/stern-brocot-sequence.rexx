/*REXX program generates & displays a Stern─Brocot sequence; finds 1─based indices; GCDs*/
parse arg N idx fix chk .                        /*get optional arguments from the C.L. */
if   N=='' |   N==","  then   N=  15             /*Not specified?  Then use the default.*/
if idx=='' | idx==","  then idx=  10             /* "      "         "   "   "     "    */
if fix=='' | fix==","  then fix= 100             /* "      "         "   "   "     "    */
if chk=='' | chk==","  then chk=1000             /* "      "         "   "   "     "    */

say center('the first'      N      "numbers in the Stern─Brocot sequence", 70, '═')
a=Stern_Brocot(N)                                /*invoke function to generate sequence.*/
say a                                            /*display the sequence to the terminal.*/
say
say center('the 1─based index for the first'       idx       "integers",   70, '═')
a=Stern_Brocot(-idx)                             /*invoke function to generate sequence.*/
w=length(idx);         do i=1  for idx
                       say 'for '   right(i, w)",  the index is: "         wordpos(i, a)
                       end   /*i*/
say
say center('the 1─based index for'  fix, 70, "═")
a=Stern_Brocot(-fix)                             /*invoke function to generate sequence.*/
say 'for '   fix",  the index is: "    wordpos(fix, a)
say
say center('checking if all two consecutive members have a GCD=1', 70, '═')
a=Stern_Brocot(chk)                              /*invoke function to generate sequence.*/
                       do c=1  for chk-1;    if gcd(subword(a, c, 2))==1  then iterate
                       say 'GCD check failed at index'         c;         exit 13
                       end   /*c*/

say '───── All '     chk     " two consecutive members have a GCD of unity."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
gcd: procedure; $=;     do i=1  for arg();     $=$ arg(i)               /*get arg list. */
                        end   /*i*/
     parse var $ x z .;                if x=0  then x=z                 /*is zero case? */
     x=abs(x)                                                           /*use absolute x*/
               do j=2  to words($);    y=abs( word($, j) )
               if y=0  then iterate                                     /*ignore zeros. */
                  do  until y==0;      parse value x//y y  with  y x    /* ◄──heavy work*/
                  end   /*until*/
               end      /*j*/
     return x                                                           /*return the GCD*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
Stern_Brocot:  parse arg h 1 f;                  $=1 1;               if h<0  then h=1e9
                                                                              else f=0
               f=abs(f)
                             do k=2  until words($)>=h | wordpos(f, $)\==0;   _=word($, k)
                             $=$   (_ + word($, k-1) )   _
                             end   /*k*/
               if f==0  then return subword($, 1, h)
                             return $
