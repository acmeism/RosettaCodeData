/*REXX pgm computes the 1st N elements of the Lucas sequence for Metallic ratios 0──►9. */
parse arg n bLO bHI digs .                       /*obtain optional arguments from the CL*/
if    n=='' |    n==","  then    n= 15           /*Not specified?  Then use the default.*/
if  bLO=='' |  bLO==","  then  bLO=  0           /* "      "         "   "   "     "    */
if  bHI=='' |  bHI==","  then  bHI=  9           /* "      "         "   "   "     "    */
if digs=='' | digs==","  then digs= 32           /* "      "         "   "   "     "    */
numeric digits digs + length(.)                  /*specify number of decimal digs to use*/
metals= 'platinum  golden  silver  bronze  copper  nickel  aluminum  iron  tin  lead'
@decDigs= ' decimal digits past the decimal point:'             /*a literal used in SAY.*/
!.=                                              /*the default name for a metallic ratio*/
         do k=0  to 9;  !.k= word(metals, k+1)   /*assign the (ten) metallic ratio names*/
         end   /*k*/

      do m=bLO   to bHI;  @.= 1;  $=  1  1       /*compute the sequence numbers & ratios*/
      r=.                                        /*the ratio  (so far).                 */
         do #=2  until r=old;     old= r         /*compute sequence numbers & the ratio.*/
                    #_1= #-1;       #_2= #-2     /*use variables for previous numbers.  */
         @.#= m * @.#_1     +     @.#_2          /*calculate a number i the sequence.   */
         if #<n  then $= $  @.#                  /*build a sequence list of  N  numbers.*/
         r= @.#  /  @.#_1                        /*calculate ratio of the last 2 numbers*/
         end   /*#*/

      if words($)<n  then $= subword($ copies('1 ', n), 1, n) /*extend list if too short*/
      L= max(108, length($) )                                 /*ensure width of title.  */
      say center(' Lucas sequence for the'  !.m  "ratio,  where  B  is " m' ',  L,  "═")
      if n>0  then do;   say 'the first '    n    " elements are:";       say $
                   end                           /*if  N  is positive, then show N nums.*/
      @approx= 'approximate'                     /*literal (1 word) that is used for SAY*/
      r= format(r,,digs)                         /*limit decimal digits for  R  to digs.*/
      if datatype(r, 'W')  then do;      r= r/1;      @approx=     "exact";       end
      say 'the'  @approx  "value reached after"   #-1   " iterations with "  digs @DecDigs
      say r;                    say              /*display the ration plus a blank line.*/
      end      /*m*/                             /*stick a fork in it,  we're all done. */
