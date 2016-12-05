/*REXX program  converts  Roman numeral number(s)  ───►  Arabic numerals  (or numbers). */
numeric digits 1000                              /*so we can handle the big numbers.    */
parse arg z                                      /*obtain optional arguments from the CL*/
if z=''  then z= "MCMXC mmviii IIXX LU MDCLXVI MDWLXVI ((mmm)) [[[[[D]]]]]"  /*defaults.*/

     do j=1  for words(z);   y=word(z, j)        /*process each of the Roman numbers.   */
     say  right(y, 20)':'    rom2dec(y)          /*display original and decimal version.*/
     end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
rom2dec:  procedure;   h='0'x;   #=0;   $=1;   arg n .         /*"ARG"  uppercases  N.  */
n=translate(n, '()()', "[]{}");  _=verify(n, 'MDCLXVUIJ()')    /*trans grouping symbols.*/
if _\==0  then return '***error*** invalid Roman numeral:'  substr(n,_,1)   /*tell error*/
@.=1; @.m=1000; @.d=500; @.c=100; @.l=50; @.x=10; @.u=5; @.v=5 /*Roman numeral values.  */
                                                               /* [↓]  convert number.  */
   do k=length(n)  to 1  by -1;  _=substr(n, k, 1)             /*examine a Roman numeral*/
                                                               /* [↑]  scale up or down.*/
   if _=='(' | _==")"  then  do;  $=$*1000; if _=='(' then $=1 /* (≡scale ↑;  )≡scale ↓ */
                                  iterate                      /*go & process next digit*/
                             end
   _=@._*$                                                     /*scale it if necessary. */
   if _>h  then h=_                                            /*remember Roman numeral.*/
   if _<h  then #=#-_                                          /*char>next?  Then sub.  */
           else #=#+_                                          /*            else add.  */
   end   /*k*/
return #                                                       /*return Arabic number.  */
