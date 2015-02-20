/*──────────────────────────────────SQRT subroutine─────────────────────*/
sqrt: procedure;   r=                  /*returns principal SQRT of args.*/
           do j=1  for arg()           /*process each argument specified*/
           a=arg(j)                    /*extract  the argument specified*/
               do k=1  for words(a)    /*process each number specified. */
               r=r sqrt_(word(a,k))    /*calculate sqrt, add to results.*/
               end   /*k*/             /* [↑]  process each # in Nth arg*/
           end       /*j*/             /* [↑]  process each #s in args. */
return r                               /*return list of SQRTs calculated*/
/*──────────────────────────────────SQRT_ subroutine────────────────────*/
sqrt_: procedure;  parse arg x;        if x=0  then return 0  /*handle 0*/
if pos(',',x)\==0   then x=space(translate(x,,","),0)     /*elide comma.*/
if \datatype(x,'N') then return '[n/a]' /*not numberic?   not applicable*/
ox=x                                   /*save the original value of  X. */
x=abs(x)                               /*just use positive value of  X. */
d=digits()                             /*get the current precision.     */
m.=11                                  /*technique uses just enough digs*/
numeric digits m.                      /*use "small" precision at first.*/
numeric form                           /*force scientific form of number*/
parse value format(x,2,1,,0) 'E0' with g 'E' _ .     /*get X's exponent.*/
g=g * .5'E'_ % 2                       /*1st guesstimate for square root*/
p=d + d%4 + 2                          /*# of iterations (calculations).*/
                                       /*Note: to insure enough accuracy*/
                                       /*for the result, the precsion   */
                                       /*during the SQRT calcuations is */
                                       /*increased by two extra digits. */
  do j=0  while  p>9;  m.j=p;  p=p%2+1 /*compute the sizes of precision.*/
  end   /*j*/                          /* [↑]  precisions stored in  M. */
                                       /* [↓]  da rubber meets da road. */
  do k=j+5  to 0  by -1                /*compute √ with increasing digs.*/
  numeric digits m.k                   /*each iteration, increase digits*/
  g=(g+x/g) * .5                       /*do the nitty-gritty calculation*/
  end   /*k*/                          /* [↑]  .5*  is faster than  /2  */
                                       /* [↓]  normalize√──►original dig*/
numeric digits d                       /*restore the original precision.*/
return (g/1)left('i',ox<0)             /*normalize, add possible suffix.*/
