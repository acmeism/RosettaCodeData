/*REXX pgm (pathological FP problem): the chaotic bank society offering a new investment*/
e=2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713,
  ||8217852516642742746639193200305992181741359662904357290033429526059563073813232862794,
  ||3490763233829880753195251019011573834187930702154089149934884167509244761460668082264,
  ||8001684774118537423454424371075390777449920695517027618386062613313845830007520449338
d = length(e)  -  length(.)                      /*subtract one for the decimal point.  */
parse arg digs show y .                          /*obtain optional arguments from the CL*/
if digs==''  |  digs==","  then digs=  d         /*Not specified?  Then use the default.*/
if show==''  |  show==","  then show= 20         /* "      "         "   "   "     "    */
if    y==''  |     y==","  then    y= 25         /* "      "         "   "   "     "    */
numeric digits digs                              /*have REXX use "digs" decimal digits. */
$= e - 1                                         /*subtract $1 from e, that's da deposit*/
                                                 /* [↑]  value of newly opened account. */
                           do n=1  for y         /*compute the value of the account/year*/
                           $= $*n  -  1          /*   "     "    "    "  "  account now.*/
                           end   /*n*/
@@@= 'With '     d      " decimal digits, the balance after "      y      ' years is: '
say @@@    '$'format($, , show) / 1              /*stick a fork in it,  we're all done. */
