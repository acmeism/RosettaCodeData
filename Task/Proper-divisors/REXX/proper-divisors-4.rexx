/*REXX program finds proper divisors (and count) of integer ranges; finds the max count.*/
parse arg bot top inc range xtra                 /*obtain optional arguments from the CL*/
if   bot=='' |   bot==","  then    bot=     1    /*Not specified?  Then use the default.*/
if   top=='' |   top==","  then    top=    10    /* "      "         "   "   "     "    */
if   inc=='' |   inc==","  then    inc=     1    /* "      "         "   "   "     "    */
if range=='' | range==","  then  range= 20000    /* "      "         "   "   "     "    */
w= max( length(top), length(bot), length(range)) /*determine the biggest number of these*/
numeric digits max(9, w + 1)                     /*have enough digits for  //  operator.*/
@.= 'and'                                        /*a literal used to separate #s in list*/
      do n=bot  to top  by inc                   /*process the first range specified.   */
      q= Pdivs(n);    #= words(q)                /*get proper divs; get number of Pdivs.*/
      if q=='∞'  then #= q                       /*adjust number of Pdivisors for zero. */
      say right(n, max(20, w) )   'has'   center(#, 4)     "proper divisors: "    q
      end   /*n*/
m= 0                                             /*M ≡ maximum number of Pdivs (so far).*/
      do r=1  for range;    q= Pdivs(r)          /*process the second range specified.  */
      #= words(q);          if #<m  then iterate /*get proper divs; get number of Pdivs.*/
      if #<m  then iterate                       /*Less then max?   Then ignore this #. */
      @.#= @.#  @.  r;      m=#                  /*add this Pdiv to max list; set new M.*/
      end   /*r*/                                /* [↑]   process 2nd range of integers.*/
say
say m  ' is the highest number of proper divisors in range 1──►'range,
       ", and it's for: "       subword(@.m, 3)
say                                              /* [↓]  handle any given extra numbers.*/
      do i=1  for words(xtra);  n= word(xtra, i) /*obtain an extra number from XTRA list*/
      w= max(w, 1 + length(n) )                  /*use maximum width for aligned output.*/
      numeric digits max(9, 1 + length(n) )      /*have enough digits for  //  operator.*/
      q= Pdivs(n);              #= words(q)      /*get proper divs; get number of Pdivs.*/
      say  right(n, max(20, w) )     'has'     center(#, 4)      "proper divisors."
      end   /*i*/                                /* [↑] support extra specified integers*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
iSqrt: procedure; parse arg x;  r=0;  q=1;             do while q<=x;  q=q*4;  end
                  do while q>1; q=q%4; _=x-r-q; r=r%2; if _>=0 then do;x=_;r=r+q; end; end
       return r
/*──────────────────────────────────────────────────────────────────────────────────────*/
Pdivs: procedure; parse arg x,b;  x= abs(x)
                                  if x==1  then return ''                    /*null set.*/
                                  if x==0  then return '∞'                   /*infinity.*/
       odd= x // 2                               /*oddness of  X.        ___            */
       r= iSqrt(x)                               /* obtain the integer  √ X             */
       a= 1                                      /* [↓]  use all,  or only odd numbers. */
                                                 /*                                  ___*/
       if odd then do j=3  by 2 for r%2-(r*r==x) /*divide by some integers up to    √ X */
                   if x//j==0  then do;  a=a j; b=x%j b /*÷?  Add both divisors to A & B*/
                                    end
                   end   /*j*/                   /*                                  ___*/
              else do j=2       for r-1-(r*r==x) /*divide by some integers up to    √ X */
                   if x//j==0  then do;  a=a j; b=x%j b /*÷?  Add both divisors to A & B*/
                                    end
                   end   /*j*/
       if r*r==x  then  return  a j b            /*Was  X  a square?    If so, add  √ X */
                        return  a   b            /*return proper divisors  (both lists).*/
