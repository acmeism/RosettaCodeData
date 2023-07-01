/*REXX program finds and displays  Pierpont primes  of the  first  and  second  kinds.  */
parse arg n .                                    /*obtain optional argument from the CL.*/
if n=='' | n==","  then n= 50                    /*Not specified?  Then use the default.*/
numeric digits n                                 /*ensure enough decimal digs (bit int).*/
big= copies(9, digits() )                        /*BIG:  used as a max number (a limit).*/
@.= '2nd';                      @.1= '1st'
        do t=1  to -1  by -2;   usum= 0;   vsum= 0;    s= 0       /*T  is  1,  then  -1.*/
        #= 0                                     /*number of Pierpont primes  (so far). */
        $=;    do j=0  until #>=n                /*$:   the list  "  "      "      "    */
               if usum<=s  then usum= get(2, 3);    if vsum<=s  then vsum= get(3, 2)
               s= min(vsum, usum);  if \isPrime(s)  then iterate /*get min;  Not prime? */
               #= # + 1;            $= $ s                       /*bump counter; append.*/
               end   /*j*/
        say
        w= length(word($, #) )                                   /*biggest prime length.*/
        say center(n   " Pierpont primes of the "   @.t ' kind',  max(10 *(w+1), 80), "═")

          do p=1  by 10  to #;      _=;      do k=p  for 10;   _= _ right( word($, k),  w)
                                             end   /*k*/
          if _\==''  then say substr( strip(_, "T"),  2)
          end   /*p*/
        end     /*t*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isPrime: procedure; parse arg x '' -1 _; if x<17  then return wordpos(x,"2 3 5 7 11 13")>0
         if _==5  then return 0;           if x//2==0  then return 0       /*not prime. */
         if x//3==0  then return 0;        if x//7==0  then return 0       /* "    "    */
            do j=11  by 6  until j*j>x                                     /*skip ÷ 3's.*/
            if x//j==0  then return 0;  if x//(j+2)==0  then return 0      /*not prime. */
            end   /*j*/;                                     return 1      /*it's prime.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
get: parse arg c1,c2; m=big;  do   ju=0;  pu= c1**ju;  if pu+t>s  then return min(m, pu+t)
                                do jv=0;  pv= c2**jv;  if pv  >s  then iterate ju
                                _= pu*pv  +  t;        if _   >s  then m= min(_, m)
                                end   /*jv*/
                              end     /*ju*/           /*see the    RETURN    (above).  */
