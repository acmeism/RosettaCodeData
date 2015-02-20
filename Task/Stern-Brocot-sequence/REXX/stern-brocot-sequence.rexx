/*REXX pgm gens/shows Stern-Brocot sequence, finds 1-based indices, GCDs*/
parse arg N idx fix chk .              /*get optional argument from C.L.*/
if   N=='' |   N==','  then   N=  15   /*use the default for    N ?     */
if idx=='' | idx==','  then idx=  10   /* "   "     "     "   idx ?     */
if fix=='' | fix==','  then fix= 100   /* "   "     "     "   fix ?     */
if chk=='' | chk==','  then chk=1000   /* "   "     "     "   chk ?     */
                                       /*═══════════════════════════════*/
say center('the first'  N  'numbers in the Stern-Brocot sequence', 70,'═')
a=Stern_Brocot(N)                      /*invoke function to generate seq*/
say a                                  /*display sequence to terminal.  */
                                       /*═══════════════════════════════*/
say center('the 1-based index for the first'  idx  "integers",  70, '═')
a=Stern_Brocot(-idx)                   /*invoke function to generate seq*/
       do i=1  for idx
       say 'for '  right(i,length(idx))",  the index is: "    wordpos(i,a)
       end   /*i*/
                                       /*═══════════════════════════════*/
say center('the 1-based index for'  fix,  70, '═')
a=Stern_Brocot(-fix)                   /*invoke function to generate seq*/
say 'for '  fix",  the index is: "   wordpos(fix,a)
                                       /*═══════════════════════════════*/
say center('checking if all two consecutive members have a GCD=1', 70,'═')
a=Stern_Brocot(chk)                    /*invoke function to generate seq*/
       do c=1  for chk-1;       if gcd(subword(a,c,2))==1  then iterate
       say 'GCD check failed at member'  c".";  exit 13
       end   /*c*/
say '───── All '    chk    " two consecutive members have a GCD of unity."
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────GCD subroutine──────────────────────*/
gcd: procedure; $=;   do i=1  for arg();   $=$ arg(i);  end   /*arg list*/
parse var $ x z .;  if x=0  then x=z            /*handle special 0 case.*/
x=abs(x)
          do j=2  to words($);  y=abs(word($,j));  if y=0  then iterate
            do  until _==0; _=x//y; x=y; y=_; end     /*◄──heavy lifting*/
          end   /*j*/
return x
/*──────────────────────────────────STERN_BROCOT subroutine.────────────*/
Stern_Brocot:  parse arg h 1 f;   if h<0  then h=1e9; else f=0;   f=abs(f)
$=1 1
       do k=2  until  words($)>=h;   _=word($,k);    $=$ (_+word($,k-1)) _
       if f==0  then iterate;        if wordpos(f,$)\==0  then leave
       end   /*until*/

if f==0  then return subword($,1,h)
              return $
