/*REXX pgm finds:  1st N Brazilian #s;  odd Brazilian #s;  prime Brazilian #s;  ZZZth #.*/
parse arg  t.1  t.2  t.3  t.4  .                 /*obtain optional arguments from the CL*/
if t.4=='' | t.4==","  then t.4= 0               /*special test case of Nth Brazilian #.*/
hdr.1= 'first';   hdr.2= "first odd";   hdr.3= 'first prime';   hdr.4=   /*four headers.*/
                                        #p= 0    /*#P:   the number of primes  (so far).*/
    do c=1  for 4                                /*process each of the four cases.      */
    if t.c=='' | t.c==","  then t.c= 20          /*check if a target is null or a comma.*/
    step= 1 + (c==2)                             /*STEP is set to unity or two (for ODD)*/
    if t.c==0  then iterate                      /*check to see if this case target ≡ 0.*/
    $=;                       #= 0               /*initialize list to null; counter to 0*/
       do j=1  by step  until #>= t.c            /*search integers for Brazilian # type.*/
       prime= 0                                  /*signify if  J  may not be prime.     */
       if c==3  then do                          /*is this a  "case 3"  calculation?    */
                     if \isPrime(j) then iterate /*(case 3)  Not a prime?  Then skip it.*/
                     prime= 1                    /*signify if  J  is definately a prime.*/
                     end                         /* [↓] J≡prime will be used for speedup*/
       if \isBraz(j, prime)  then iterate        /*Not  Brazilian number?   "    "    " */
       #= # + 1                                  /*bump the counter of Brazilian numbers*/
       if c\==4  then $= $  j                    /*for most cases, append J to ($) list.*/
       end   /*j*/                               /* [↑] cases 1──►3, $ has leading blank*/
    say                                          /* [↓]  use a special header for cases.*/
    if c==4  then do;  $= j;  t.c= th(t.c);  end /*for Nth Brazilian number, just use J.*/
    say center(' 'hdr.c" "    t.c      " Brazilian number"left('s',  c\==4)" ",  79,  '═')
    say strip($)                                 /*display a case result to the terminal*/
    end      /*c*/                               /* [↑] cases 1──►3 have a leading blank*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isBraz:  procedure; parse arg x,p;  if x<7      then return 0  /*Is # < seven?  Nope.   */
                                    if x//2==0  then return 1  /*Is # even?     Yup.   _*/
         if p  then mx= iSqrt(x)                               /*X prime? Use integer √X*/
               else mx= x%3 -1                                 /*X  not known if prime. */
                              do b=2  for mx                   /*scan for base 2 ──► max*/
                              if sameDig(x, b)  then return 1  /*it's a Brazilian number*/
                              end   /*b*/;           return 0  /*not  "     "        "  */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isPrime: procedure expose @. !. #p; parse arg x '' -1 _ /*get 1st arg & last decimal dig*/
         if #p==0 then do;  !.=0;  y= 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67
                         do i=1  for words(y);  #p= #p+1; z=word(y,i); @.#p= z; !.z=1; end
                       end                              /*#P:  is the number of primes. */
         if !.x      then return 1;   if x<61  then return 0;  if x//2==0  then return 0
         if x//3==0  then return 0;   if _==5  then return 0;  if x//7==0  then return 0
            do j=5  until @.j**2>x;                 if x//@.j     ==0  then return 0
                                                    if x//(@.j+2) ==0  then return 0
            end   /*j*/;   #p= #p + 1;   @.#p= x;   !.x= 1;    return 1  /*it's a prime.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
iSqrt:   procedure; parse arg x;     q= 1;     r= 0;        do while q<=x;   q= q*4;   end
          do while q>1; q=q%4; _=x-r-q; r=r%2; if _>=0 then do;x=_;r=r+q;end;end; return r
/*──────────────────────────────────────────────────────────────────────────────────────*/
sameDig: procedure; parse arg x, b;           f= x // b        /* //  ◄── the remainder.*/
                                              x= x  % b        /*  %  ◄── is integer  ÷ */
                    do while x>0;  if x//b \==f  then return 0
                    x= x % b
                    end   /*while*/;      return 1             /*it has all the same dig*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
th: parse arg th; return th || word('th st nd rd', 1+(th//10)*(th//100%10\==1)*(th//10<4))
