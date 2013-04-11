/*─────────────────────────────────────SQRT subroutine──────────────────*/
sqrt: procedure                        /*square root subroutine.        */
                                       /*returns the principal SQRT.    */

r=''                                   /*list of square roots calculated*/
  do j=1 for arg()                     /*process each argument specified*/
  a=arg(j)                             /*extract  the argument specified*/
    do k=1 for words(a)                /*process each number specified. */
    r=r sqrt_(word(a,k))               /*calculate sqrt, add to results.*/
    end
  end
return space(r)                        /*return list of SQRTs calculated*/


/*─────────────────────────────────────SQRT_ subroutine─────────────────*/
sqrt_: procedure; parse arg x 1 ox
if x=0 then return 0                   /*handle special case of zero.   */
if x='' then return ''                 /*if null, then return null.     */
if pos(',',x)\==0 then do;x=space(translate(x,,","),0);ox=x;end  /*del ,*/
if \datatype(x,'N') then return '[n/a]' /*not numberic?   not applicable*/
x=abs(x)                               /*just use positive value of  X. */
d=digits()                             /*get the current precision.     */
numeric digits 11                      /*use "small" precision at first.*/
g=sqrt_guess()                         /*try get a good 1st guesstimate.*/
m.=11                                  /*technique uses just enough digs*/
p=d+d%4+2                              /*# of iterations (calculations).*/

                                       /*Note: to insure enough accuracy*/
                                       /*for the result, the precsion   */
                                       /*during the SQRT calcuations is */
                                       /*increased by two extra digits. */
  do j=0 while p>9
  m.j=p
  p=p%2+1
  end

  do k=j+5 to 0 by -1
  if m.k>11 then numeric digits m.k    /*each iteration, increase digits*/
  g=.5*(g+x/g)                         /*do the nitty-gritty calculation*/
  end                                  /*  .5*   is faster than    /2   */

numeric digits d                       /*restore the original precision.*/
return (g/1)left('i',ox<0)             /*normalize to old digs, complex?*/


sqrt_guess: numeric form scientific    /*force scientific form of number*/
parse value format(x,2,1,,0) 'E0' with g 'E' _ .     /*get X's exponent.*/
return g*.5'E'_%2                                    /*1st guesstimate. */


/*┌────────────────────────────────────────────────────────────────────┐
┌─┘                               √                                    └─┐
│ While the above REXX code seems like it's doing a lot of extra work,   │
│ it saves a substanial amount of processing time when the precision     │
│ (DIGITs) is a lot greater than the default (9 digits).                 │
│                                                                        │
│ Indeed, when computing square roots in the hundreds (even thousands)   │
│ of digits,  this technique reduces the amount of CPU processing time   │
│ by keeping the length of the computations to a minimim (due to a large │
│ precision)  while the accuracy (at the beginning)  isn't important for │
│ caculating the guesstimate  (the running square root guess).           │
└─┐                               √                                    ┌─┘
  └────────────────────────────────────────────────────────────────────┘*/
