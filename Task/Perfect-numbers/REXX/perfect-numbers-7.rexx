/*REXX program tests if a number  (or a range of numbers)   is/are  perfect.            */
parse arg low high .                             /*obtain optional arguments from the CL*/
if high=='' & low==""  then high=34000000        /*No arguments?    Then use a range.   */
if  low==''            then  low=1               /*if no   LOW,  then assume unity.     */
low=low+low//2                                   /*if LOW is odd,  bump it by one.      */
if high==''            then high=low             /*if no  HIGH,  then assume  LOW.      */
w=length(high)                                   /*use   W   for formatting the output. */
numeric digits max(9,w+2)                        /*ensure enough decimal digits for nums*/
@. =0;    @.1=2;     !.=2;     _=' 6'            /*highest  magic number  and its index.*/
!._=22;   !.16=12;   !.28=8;   !.36=20;   !.56=20;   !.76=20;   !.96=20
                                                 /* [↑]   "Lucas' numbers,  in 1891.    */
            do i=low  to high  by 0              /*process the single number or a range.*/
            if isPerfect(i)  then say  right(i,w)   'is a perfect number.'
            i=i+!.?                              /*use a fast advance for the DO index. */
            end   /*i*/                          /* [↑]  note: the DO index is modified.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isPerfect: procedure expose @. !. ?              /*expose (make global) some variables. */
           parse arg  x  1  y  ''  -2  ?         /*#  (and copy), and the last 2 digits.*/
           if x==6    then return 1              /*handle the special case of  six.     */
           if !.?==2  then return 0              /*test last two digits: François Lucas.*/
                                       /*╔═════════════════════════════════════════════╗
                                         ║ Lucas─Lehmer know that perfect numbers can  ║
                                         ║ be expressed as:    [2^n -1] * {2^(n-1) }   ║
                                         ╚═════════════════════════════════════════════╝*/
           if @.0<x  then do @.1=@.1  while @._<=x;  _=(2**@.1-1)*2**(@.1-1); @.0=_; @._=_
                          end   /*@.1*/          /* [↑]  uses memoization for formula.  */

           if @.x==0  then return 0              /*Didn't pass Lucas-Lehmer? Not perfect*/
                                                 /*[↓]  perfect numbers digital root = 1*/
                 do  until  y<10                 /*find the digital root of  Y.         */
                 parse var y d 2;  do k=2  for length(y)-1; d=d+substr(y,k,1);  end  /*k*/
                 y=d                             /*find digital root of the digital root*/
                 end   /*until*/                 /*wash, rinse, repeat ···              */

           if d\==1  then return 0               /*Is digital root ¬ 1?  Then ¬ perfect.*/
           s=3 + x%2                             /*we know the following factors: unity,*/
           z=x                                   /*2,  and  x÷2   (x is even).          */
           q=1;  do  while q<=z;   q=q*4 ;  end  /*while q≤z*/            /*       _____*/
           r=0                                   /* [↓]    R  will be the integer √  X  */
                 do  while q>1;  q=q%4; _=z-r-q; r=r%2;  if _>=0  then do; z=_; r=r+q; end
                 end   /*while q>1*/             /* [↑]  compute the integer SQRT of  X.*/
                                                 /*                                _____*/
                      do j=3  to r               /*starting at 3,  find factors ≤ √  X  */
                      if x//j==0  then s=s+j+x%j /*J divisible by X? Then add J and  X÷J*/
                      end   /*j*/
           return s==x                           /*if the sum matches X,  then perfect! */
