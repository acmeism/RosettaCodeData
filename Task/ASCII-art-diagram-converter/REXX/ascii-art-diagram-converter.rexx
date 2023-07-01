/*REXX program  interprets  an  ASCII art diagram  for  names  and  their bit length(s).*/
numeric digits 100                               /*be able to handle large numbers.     */
er= '***error*** illegal input txt'              /*a literal used for error messages.   */
parse arg iFID test .                            /*obtain optional input─FID & test─data*/
if iFID=='' | iFID==","  then iFID= 'ASCIIART.TXT'               /*use the default iFID.*/
if test=='' | test==","  then test= 'cafe8050800000808080000a'   /* "   "     "    data.*/
w= 0;         wb= 0;      !.= 0;     $=          /*W   (max width name),  bits,  names. */
@.= 0;        @.0= 1                             /*!.α   is structure bit position.     */
                                                 /* [↓]  read the input text file (iFID)*/
    do j=1  while lines(iFID)\==0;     q= linein(iFID);             say  '■■■■■text►'q
    q= strip(q);          if q==''  then iterate /*strip leading and trailing blanks.   */
    _L= left(q, 1);       _R= right(q, 1)        /*get extreme left and right characters*/
                                                 /* [↓]  is this record an "in-between"?*/
    if _L=='+'  then do;  if verify(q, '+-')\==0  then say er    "(invalid grid):"     q
                          iterate                /*skip this record, it's a single "+". */
                     end
    if _L\=='|'  |  _R\=="|"   then do;   say er  '(boundary): '   q;   iterate
                                    end
       do  until q=='|';  parse var  q    '|'  x  "|"  -1  q   /*parse record for names.*/
       n= strip(x);       w= max(w, length(n) );   if n==''  then leave     /*is N null?*/
       if words(n)\==1         then do;  say er '(invalid name): '  n;     iterate j
                                    end          /* [↑]  add more name validations.     */
       $$= $;     nn= n;  upper $$ n             /*$$ and N  could be a mixed─case name.*/
       if wordpos(nn, $$)\==0  then do;  say er '(dup name):'       n;     iterate j
                                    end
       $= $ n                                    /*add the   N   (name)  to the $ list. */
       #= words($);     !.#= (length(x) + 1) % 3 /*assign the number of bits for  N.    */
       wb= max(wb, !.#)                          /*max # of bits; # names prev. to this.*/
       prev= # - 1;     @.#= @.prev + !.prev     /*number of names previous to this name*/
       end   /*until*/
    end      /*j*/
say
if j==1  then do;   say er   '   (file not found): '     iFID;            exit 12
              end
     do k=1  for words($)
     say right( word($, k), w)right(!.k, 4)        "bits,  bit position:"right(@.k, 5)
     end   /*k*/
say                                              /* [↓]  Any (hex) data to test?        */
L= length(test);      if L==0  then exit         /*stick a fork in it,  we're all done. */
bits= x2b(test)                                  /*convert test data to a bit string.   */
wm= length( x2d( b2x( copies(1, wb) ) ) )  +  1  /*used for displaying max width numbers*/
say 'test (hex)='    test                 "    length="   L          'hexadecimal digits.'
say
       do r=1  by 8+8  to L*4;   _1= substr(bits, r, 8, 0);    _2= substr(bits, r+8, 8, 0)
       say 'test (bit)='    _1   _2   "   hex="    lower( b2x(_1) )     lower( b2x(_2) )
       end   /*r*/
say
       do m=1  for words($)                      /*show some hexadecimal strings──►term.*/
       _= lower( b2x( substr( bits, @.m, !.m) )) /*show the hex string in lowercase.    */
       say right( word($, m), w+2)     '  decimal='right( x2d(_), wm)      "      hex="  _
       end   /*m*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
lower: l= 'abcdefghijklmnopqrstuvwxyz';  u=l;  upper u;    return translate( arg(1), l, u)
