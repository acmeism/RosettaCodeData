/*REXX program uses the  Ramer─Douglas─Peucker (RDP)  line simplification algorithm  for*/
/*───────────────────────────── reducing the number of points used to define its shape. */
parse arg epsilon pts                            /*obtain optional arguments from the CL*/
if epsilon='' | epsilon=","   then epsilon= 1    /*Not specified?  Then use the default.*/
if pts=''  then pts= '(0,0) (1,0.1) (2,-0.1) (3,5) (4,6) (5,7) (6,8.1) (7,9) (8,9) (9,9)'
pts= space(pts)                                  /*elide all superfluous blanks.        */
            say '  error threshold: '   epsilon  /*echo the error threshold to the term.*/
            say ' points specified: '   pts      /*  "   "    shape points   "  "    "  */
$= RDP(pts)                                      /*invoke Ramer─Douglas─Peucker function*/
            say 'points simplified: '   rez($)   /*display points with () ───► terminal.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
bld: parse arg _; #= words(_); dMax=-#; idx=1; do j=1  for #; @.j= word(_, j); end; return
px:  parse arg _;          return word( translate(_, , ','),  1)   /*obtain the X coörd.*/
py:  parse arg _;          return word( translate(_, , ','),  2)   /*   "    "  Y   "   */
reb: parse arg a,b,,_;                  do k=a  to b;  _= _ @.k;    end;   return strip(_)
rez: parse arg z,_;   do k=1  for words(z); _= _ '('word(z, k)") "; end;   return strip(_)
/*──────────────────────────────────────────────────────────────────────────────────────*/
RDP: procedure expose epsilon;    call bld  space( translate(arg(1), , ')(][}{') )
     L= px(@.#) - px(@.1)
     H= py(@.#) - py(@.1)                        /* [↓] find point IDX with max distance*/
                         do i=2  to #-1
                         d= abs(H*px(@.i) - L*py(@.i) + px(@.#)*py(@.1) - py(@.#)*px(@.1))
                         if d>dMax  then do;   idx= i;   dMax= d
                                         end
                         end   /*i*/             /* [↑]  D is the perpendicular distance*/

     if dMax>epsilon  then do;   r= RDP( reb(1, idx) )
                                 return subword(r, 1, words(r) - 1)     RDP( reb(idx, #) )
                           end
     return @.1  @.#
