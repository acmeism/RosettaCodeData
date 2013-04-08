/*REXX program calculates the information entropy  for a given char str.*/
numeric digits 30                      /*use thirty digits for precision*/
parse arg $;         if $=='' then $=1223334444  /*obtain optional input*/
n=0;  @.=0;  L=length($);  $$=

      do j=1  for L;  _=substr($,j,1)  /*process each character in $ str*/
      if @._==0  then do;   n=n+1      /*if unique,  bump char counter. */
                      $$=$$ || _       /*add this character to the list.*/
                      end
      @._ = @._+1                      /*keep track of this char count. */
      end   /*j*/
sum=0                                  /*calc info entropy for each char*/
      do i=1  for n;  _=substr($$,i,1) /*obtain a char from unique list.*/
      sum=sum  -  @._/L  * log2(@._/L) /*add (negatively) the entropies.*/
      end   /*i*/

say ' input string: ' $
say 'string length: ' L
say ' unique chars: ' n ;       say
say 'the information entropy of the string âââº ' format(sum,,12)  " bits."
exit                                   /*stick a fork in it, we're done.*/
/*ââââââââââââââââââââââââââââââââââLOG2 subroutineâââââââââââââââââââââ*/
log2: procedure; parse arg x 1 xx;    ig= x>1.5;   is=1-2*(ig\==1);   ii=0
numeric digits digits()+5      /* [â] precision of E must be > digits().*/
e=2.7182818284590452353602874713526624977572470936999595749669676277240766303535
    do  while  ig & xx>1.5 | \ig&xx<.5;   _=e;     do k=-1;  iz=xx* _**-is
    if k>=0 & (ig & iz<1 | \ig&iz>.5)     then leave;  _=_*_;  izz=iz; end
    xx=izz;  ii=ii+is*2**k;  end;         x=x* e**-ii-1;  z=0;  _=-1;  p=z
      do k=1;  _=-_*x;  z=z+_/k;  if z=p  then leave;  p=z;  end  /*k*/
    r=z+ii;  if arg()==2  then return r;  return r/log2(2,0)
