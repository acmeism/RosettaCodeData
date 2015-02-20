/*REXX program lists # of chars in a fibonacci word, the word's entropy.*/
numeric digits 20                      /*use more precision,  default=9.*/
parse arg N !.1 !.2 .                  /*get optional args from the C.L.*/
if   N==''  then   N=37                /*Not specified? Then use default*/
if !.1==''  then !.1=1                 /* "      "        "   "     "   */
if !.2==''  then !.2=0                 /* "      "        "   "     "   */
say center('N',5) center('length',12) center('entropy',digits()+6) center('Fib word',35)
say copies('─',5) copies('─'     ,12) copies('─'      ,digits()+6) copies('─'       ,35)

      do j=1  for N;  j1=j-1;  j2=j-2  /*display  N  fibonacci words.   */
      if j>2  then !.j=!.j1 || !.j2    /*calculate FIBword if we need to*/
      if length(!.j)<35  then Fw= !.j
                         else Fw= '{the word is too wide to display}'
      say  right(j,4)   right(length(!.j),12)  '  '   entropy(!.j) '  ' Fw
      end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ENTROPY subroutine──────────────────*/
entropy: procedure;  parse arg $;      L=length($);     d=digits()
if L==1  then return left(0,d+2)       /*handle special case of one char*/
@.0=L-length(space(translate($,,0),0)) /*fast way to count zeroes.      */
@.1=L-@.0                              /*and figure the number of ones. */
S=0                                    /* [↓] calc entropy for each char*/
      do i=1  for 2;  _=i-1            /*construct a chr from the ether.*/
      S = S - @._/L * log2(@._/L)      /*add (negatively) the entropies.*/
      end   /*i*/
if S=1  then return left(1,d+2)        /*return a left-justified  "1".  */
return format(S,,d)                    /*normalize the number (sum or S).    */
/*──────────────────────────────────LOG2 subroutine───────────────────────────*/
log2: procedure; parse arg x 1 xx;  ig= x>1.5;  is=1-2*(ig\==1);  ii=0
numeric digits digits()+5      /* [↓] precision of E must be > digits().*/
e=2.7182818284590452353602874713526624977572470936999595749669676277240766303535
  do  while  ig & xx>1.5 | \ig&xx<.5;   _=e;       do j=-1;  iz=xx* _**-is
  if j>=0 then if ig & iz<1 | \ig&iz>.5 then leave;  _=_*_;  izz=iz;  end  /*j*/
  xx=izz;  ii=ii+is*2**j;  end /*while*/;       x=x* e**-ii-1;  z=0;  _=-1;  p=z
    do k=1;  _=-_*x;  z=z+_/k;  if z=p  then leave;  p=z;  end  /*k*/
  r=z+ii;  if arg()==2  then return r;  return r/log2(2,0)
