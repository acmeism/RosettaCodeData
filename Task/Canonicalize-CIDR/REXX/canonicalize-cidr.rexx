/*REXX pgm canonicalizes IPv4 addresses that are in CIDR notation  (dotted─dec/network).*/
parse arg a .                                    /*obtain optional argument from the CL.*/
if a=='' | a==","  then a= '87.70.141.1/22'    , /*Not specified?  Then use the defaults*/
                           '36.18.154.103/12'  ,
                           '62.62.197.11/29'   ,
                           '67.137.119.181/4'  ,
                           '161.214.74.21/24'  ,
                           '184.232.176.184/18'

    do i=1  for words(a);  z= word(a, i)         /*process each IPv4 address in the list*/
    parse var   z    #  '/'  -0  mask            /*get the address nodes & network mask.*/
    #= subword( translate(#, , .)  0 0 0, 1, 4)  /*elide dots from addr, ensure 4 nodes.*/
    $= #                                         /*use original node address (for now). */
    hb= 32 - substr(word(mask .32, 1), 2)        /*obtain the size of the host bits.    */
    $=;                          ##=             /*crop the host bits only if mask ≤ 32.*/
            do k=1  for 4;        _= word(#, k)  /*create a 32-bit (binary) IPv4 address*/
            ##= ##  ||  right(d2b(_), 8, 0)      /*append eight bits of the   "     "   */
            end   /*k*/                          /* [↑] ... and ensure a node is 8 bits.*/
    ##= left(##, 32-hb, 0)                       /*crop bits in host part of IPv4 addr. */
    ##= left(##, 32,    0)                       /*replace cropped bits with binary '0's*/
            do j=8  by 8  for 4                  /* [↓]  parse the four nodes of address*/
            $= $ || . || b2d(substr(##, j-7, 8)) /*reconstitute the decimal nodes.      */
            end   /*j*/                          /* [↑]  and insert a dot between nodes.*/
    say                                          /*introduce a blank line between IPv4's*/
    $= substr($, 2)                              /*elid the leading decimal point in  $ */
    say '   original IPv4 address: '  z          /*display the original  IPv4  address. */
    say '   canonicalized address: '  translate( space($), ., " ")mask  /*canonicalized.*/
    end   /*i*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
b2d: return  x2d( b2x( arg(1) ) )  +  0          /*convert binary  ───►  decimal number.*/
d2b: return  x2b( d2x( arg(1) ) )  +  0          /*   "    decimal ───►   binary    "   */
