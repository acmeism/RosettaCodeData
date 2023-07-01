/*REXX pgm finds primes whose values in other bases (2──►36) have the most diff. bases. */
parse arg widths .                               /*obtain optional argument from the CL.*/
if widths=='' | widths==","  then widths= 5      /*Not specified?  Then use the default.*/
call genP                                        /*build array of semaphores for primes.*/
names= 'one two three four five six seven eight' /*names for some low decimal numbers.  */
$.=
    do j=1  for #                                /*only use primes that are within range*/
       do b=36  by -1  for 35;  n= base(@.j, b)  /*use different bases for each prime.  */
       L= length(n);  if L>widths  then iterate  /*obtain length; Length too big?  Skip.*/
       if L==1  then $.L.n= b  $.L.n             /*Length  =  unity?   Prepend the base.*/
                else $.L.n= $.L.n  b             /*   "   ¬=    "       Append  "    "  */
       end   /*b*/
    end      /*j*/
                                                 /*display info for each of the widths. */
      do w=1  for widths;             cnt= 0     /*show for each width: cnt,number,bases*/
               bot= left(1, w, 0);    top= left(9, w, 9)      /*calculate range for DO. */
          do n=bot  to top;     y= words($.w.n)  /*find the sets of numbers for a width.*/
          if y>cnt  then do;  mxn=n;  cnt= max(cnt, y);  end  /*found a max? Remember it*/
          end   /*n*/
      say
      say;  say center(' 'word(names, w)"─character numbers that are"      ,
                       'prime in the most bases: ('cnt      "bases) ",  101, '─')
          do n=bot  to top;     y= words($.w.n)             /*search again for maximums.*/
          if y==cnt  then say n  '──►'  strip($.w.n)        /*display  ───a─── maximum. */
          end   /*n*/
      end       /*w*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
base: procedure; parse arg x,r,,z;               @= '0123456789abcdefghijklmnopqrsruvwxyz'
                    do j=1;  _= r**j;  if _>x  then leave
                    end   /*j*/
         do k=j-1  to 1  by -1;   _= r**k;  z= z || substr(@, (x % _) + 1, 1);   x= x // _
         end   /*k*/;                   return z || substr(@, x+1, 1)
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: @.1=2;  @.2=3;  @.3=5;  @.4=7;  @.5=11     /*define some low primes.              */
                       #= 5;  sq.#= @.# ** 2     /*number primes so far;  prime squared.*/
        do j=@.#+2  by 2  to 2 * 36 * 10**widths /*find odd primes from here on.        */
        parse var  j   ''  -1  _;  if _==5  then iterate     /*J is ÷ by 5? (right dig).*/
        if j//3==0  then iterate;  if j//7==0  then iterate  /*"  " " "  3?;  ÷ by  7?  */
               do k=5  while sq.k<=j             /* [↓]  divide by the known odd primes.*/
               if j//@.k==0  then iterate j      /*Is  J ÷ X?  Then not prime.     ___  */
               end   /*k*/                       /* [↑]  only process numbers  ≤  √ J   */
        #= # + 1;            @.#= j;  sq.#= j*j  /*bump # Ps; assign next P;  P squared.*/
        end          /*j*/;           return
