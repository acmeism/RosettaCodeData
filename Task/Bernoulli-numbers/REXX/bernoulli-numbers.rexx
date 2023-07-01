/*REXX program calculates  N  number of Bernoulli numbers expressed as vulgar fractions.*/
parse arg N .;     if N=='' | N==","  then N= 60 /*Not specified?  Then use the default.*/
numeric digits max(9, n*2)                       /*increase the decimal digits if needed*/
w= max(length(N), 4);      Nw= N  + w  +  N % 4  /*used for aligning (output) fractions.*/
say 'B(n)'   center("Bernoulli numbers expressed as vulgar fractions",  max(78-w, Nw) )
say copies('─',w)  copies("─", max(78-w,Nw+2*w)) /*display 2nd line of title, separators*/
!.= .;    do #=0  to  N                          /*process the numbers from  0  ──►  N. */
          b= bern(#);      if b==0  then iterate /*calculate Bernoulli number, skip if 0*/
          indent= max(0, nW - pos('/', b) )      /*calculate the alignment (indentation)*/
          say right(#, w)  left('', indent)  b   /*display the indented Bernoulli number*/
          end   /*#*/                            /* [↑]  align the Bernoulli fractions. */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
bern: parse arg x; if x==0  then return  '1/1'   /*handle the special case of  zero.    */
                   if x==1  then return '-1/2'   /*   "    "     "      "   "  one.     */
                   if x//2  then return   0      /*   "    "     "      "   "  odds > 1.*/
        do j=2  to x  by 2;      jp= j+1         /*process the positive integers up to X*/
        sn= 1 - j                                /*define the  numerator.               */
        sd= 2                                    /*   "    "   denominator.             */
                   do k=2  to j-1  by 2          /*calculate a  SN/SD  sequence.        */
                   parse var  @.k    bn  '/'  ad /*get a previously calculated fraction.*/
                   an= comb(jp, k) * bn          /*use  COMBination  for the next term. */
                   $lcm= LCM(sd, ad)             /*use Least Common Denominator function*/
                   sn= $lcm % sd * sn;  sd= $lcm /*calculate the   current  numerator.  */
                   an= $lcm % ad * an            /*    "      "      next      "        */
                   sn= sn + an                   /*    "      "    current     "        */
                   end   /*k*/                   /* [↑]  calculate the  SN/SD  sequence.*/
        sn= -sn                                  /*flip the sign for the numerator.     */
        sd= sd * jp                              /*calculate         the denominator.   */
        if sn\==1  then do;  _= GCD(sn, sd)      /*get the  Greatest Common Denominator.*/
                            sn= sn%_;   sd= sd%_ /*reduce the numerator and denominator.*/
                        end                      /* [↑]   done with the reduction(s).   */
        @.j= sn'/'sd                             /*save the result for the next round.  */
        end              /*j*/                   /* [↑]  done calculating Bernoulli #'s.*/
      return sn'/'sd
/*──────────────────────────────────────────────────────────────────────────────────────*/
comb: procedure expose !.; parse arg x,y;   if x==y  then return 1
      if !.C.x.y\==.  then return !.C.x.y                 /*combination computed before?*/
      if   x-y  <  y  then y= x-y                         /*x-y < y?   Then use a new Y.*/
      z= perm(x, y);           do j=2  for y-1;  z= z % j
                               end   /*j*/
      !.C.x.y= z;     return z                            /*assign memoization & return.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
GCD:  procedure;               parse arg x,y;                     x= abs(x)
           do  until y==0;     parse value  x//y  y    with    y  x;  end;        return x
/*──────────────────────────────────────────────────────────────────────────────────────*/
LCM:  procedure; parse arg x,y      /*X=ABS(X);  Y=ABS(Y)   not needed for Bernoulli #s.*/
                                    /*IF Y==0 THEN RETURN 0  "    "    "      "       " */
      $= x * y                                        /*calculate part of the LCM here. */
                   do  until y==0;   parse  value   x//y  y     with     y  x
                   end   /*until*/                    /* [↑]  this is a short & fast GCD*/
      return $ % x                                    /*divide the pre─calculated value.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
perm: procedure expose !.;  parse arg x,y;          if !.P.x.y\==.  then return !.P.x.y
      z= 1;       do j=x-y+1  to x;     z= z*j;     end;        !.P.x.y= z;       return z
