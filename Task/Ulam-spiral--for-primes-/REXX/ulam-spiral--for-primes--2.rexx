/*REXX pgm shows a clockwise Ulam spiral of primes in a square matrix.  */
parse arg size init char .             /*get the matrix size from the CL*/
if size=='' | size==','  then size=79  /*No size? Then use default of 79*/
if init=='' | init==','  then init= 1  /*No init? Then use default of 1 */
if char==''              then char='█' /*No char? Then use default of █ */
tot=size**2;  offset=init-1            /*numbers in spiral; start offset*/
uR.=0; bR.=0                           /*the upper/bottom right corners.*/
      do od=1 by 2 to tot; _=od**2+1+offset; uR._=1; _=_ + od; bR._=1; end
bL.=0; uL.=0                           /*the bottom/upper left corners. */
      do ev=2 by 2 to tot; _=ev**2+1+offset; bL._=1; _=_ + ev; uL._=1; end
$.=
bigP=0;  #p=0;   app=1;  inc=0;  r=1;  $=0;  minR=1;   maxR=1;   $=0;  !.=
/*──────────────────────────────────────────────construct the spiral #s.*/
  do i=init  for tot;  r=r+inc;  minR=min(minR,r);   maxR=max(maxR,r)
  x=isPrime(i);  if x  then bigP=max(bigP,i);  #p=#p+x  /*bigP, #primes.*/
  if app  then $.r=$.r ||  x                            /*append  token.*/
          else $.r= x  || $.r                           /*prepend token.*/
  if uR.i  then do;  app=1;  inc=+1;  iterate;  end     /*advance  ↓    */
  if bL.i  then do;  app=0;  inc=-1;  iterate;  end     /*   "     ↑    */
  if bR.i  then do;  app=0;  inc= 0;  iterate;  end     /*   "     ►    */
  if uL.i  then do;  app=1;  inc= 0;  iterate;  end     /*   "     ◄    */
  end   /*i*/

  do j=minR  to maxR  by 2;    jp=j+1;    $=$+1         /*fold two lines*/
    do k=1  for  length($.j);  top=substr($.j,k,1)      /*the   1st line*/
                               bot=word(substr($.jp,k,1) 0,1) /*2nd line*/
    if top  then if bot  then !.$=!.$'█'                /*has top & bot.*/
                         else !.$=!.$'▀'                /*has top,¬ bot.*/
            else if bot  then !.$=!.$'▄'                /*¬ top, has bot*/
                         else !.$=!.$' '                /*¬ top,   ¬ bot*/
     end   /*k*/
   end     /*j*/                       /* [↓]  show prime# spiral matrix*/
                                    do m=1  for $;   say !.m;   end  /*m*/
say;  say init 'is the starting point,'  ,
      tot  'numbers used,'   #p   "primes found, largest prime:"   bigP
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────────ISPRIME subroutine──────────────────────────────*/
isPrime: procedure;  parse arg x;  if x<2  then return 0
if wordpos(x,'2 3 5 7')\==0                then return 1
if x//2==0  then return 0;  if x//3==0     then return 0
   do j=5 by 6 until j*j>x; if x//j==0 then return 0; if x//(j+2)==0 then return 0; end
return 1
