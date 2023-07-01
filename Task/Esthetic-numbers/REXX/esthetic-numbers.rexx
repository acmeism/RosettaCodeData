/*REXX pgm lists a bunch of esthetic numbers in bases 2 ──► 16, & base 10 in two ranges.*/
parse arg baseL baseH range                      /*obtain optional arguments from the CL*/
if baseL=='' | baseL==","  then baseL= 2         /*Not specified?  Then use the default.*/
if baseH=='' | baseH==","  then baseH=16         /* "      "         "   "   "     "    */
if range=='' | range==","  then range=1000..9999 /* "      "         "   "   "     "    */

     do radix=baseL  to baseH;  #= 0;  if radix<2  then iterate    /*process the bases. */
     start= radix * 4;                  stop = radix * 6
     $=;               do i=1  until #==stop;  y= base(i, radix)   /*convert I to base Y*/
                       if \esthetic(y, radix)  then iterate        /*not esthetic?  Skip*/
                       #= # + 1;   if #<start  then iterate        /*is  #  below range?*/
                       $= $ y                                      /*append # to $ list.*/
                       end   /*i*/
     say
     say center(' base '  radix",  the" th(start)   '──►'   th(stop) ,
                "esthetic numbers ",  max(80, length($) - 1),  '─')
     say strip($)
     end   /*radix*/
say;                                                                            g= 25
parse var  range   start  '..'  stop
say center(' base 10 esthetic numbers between' start "and" stop '(inclusive) ', g*5-1,"─")
                                                                 #= 0;        $=
     do k=start  to  stop;  if \esthetic(k, 10)  then iterate;   #= # + 1;    $= $ k
     if #//g==0  then do;   say strip($);  $=;   end
     end   /*k*/
say strip($);               say;                 say #   ' esthetic numbers listed.'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
PorA:  _= pos(z, @u);   p= substr(@u, _-1, 1);   a= substr(@u, _+1, 1);     return
th: parse arg th; return th || word('th st nd rd', 1+(th//10)*(th//100%10\==1)*(th//10<4))
vv: parse arg v,_;   vr= x2d(v) + _;   if vr==-1  then vr= r;               return d2x(vr)
/*──────────────────────────────────────────────────────────────────────────────────────*/
base: procedure expose @u;  arg x 1 #,toB,inB,,y /*Y  is assigned a  "null"  value.     */
      if tob==''  then tob= 10                   /*maybe assign a default for TObase.   */
      if inb==''  then inb= 10                   /*  "      "   "    "     "  INbase.   */
      @l= '0123456789abcdef';  @u= @l;  upper @u /*two versions of hexadecimal digits.  */
      if inB\==10  then do;   #= 0               /*only convert if  not  base 10.       */
                           do j=1  for length(x) /*convert  X:   base inB  ──► base 10. */
                           #= # * inB + pos(substr(x, j, 1), @u) -1  /*build new number.*/
                           end    /*j*/          /* [↑]  this also verifies digits.     */
                        end
      if toB==10   then return #                 /*if TOB is ten,  then simply return #.*/
         do  while  # >= toB                     /*convert #:    base 10  ──►  base toB.*/
         y= substr(@l, (# // toB) + 1, 1)y       /*construct the output number.         */
         #= # % toB                              /*      ··· and whittle  #  down also. */
         end    /*while*/                        /* [↑]  algorithm may leave a residual.*/
      return substr(@l, # + 1, 1)y               /*prepend the residual, if any.        */
/*──────────────────────────────────────────────────────────────────────────────────────*/
esthetic: procedure expose @u; arg x,r;       L= length(x);       if L==1  then return 1
          if x<2  then return 0
                 do d=0  to r-1;  _= d2x(d);        if pos(_ || _, x)\==0  then return 0
                 end   /*d*/                     /* [↑]  check for a duplicated digits. */
            do j=1  for L;  @.j= substr(x, j, 1) /*assign (base) digits to stemmed array*/
            end   /*j*/
          if L==2  then do;  z= @.1;   call PorA;      if @.2==p | @.2==a  then nop
                                                                           else return 0
                        end
            do e=2  to L-1;  z= @.e;   pe= e - 1;      ae= e + 1
            if (z==vv(@.pe,-1)|z==vv(@.pe,1))&(z==vv(@.ae,-1)|z==vv(@.ae,1))  then iterate
            return 0
            end   /*e*/;         return 1
