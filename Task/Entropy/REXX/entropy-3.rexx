/*REXX program calculates the   information entropy   for a specified character string. */
numeric digits length( e() ) % 2   -  length(.)  /*use 1/2 of the decimal digits of  E. */
parse arg $;   if $=''  then $= 1223334444       /*obtain the optional input from the CL*/
#=0;           @.= 0;        L= length($)        /*define handy-dandy REXX variables.   */
$$=                                              /*initialize the   $$   list.          */
       do j=1  for L;        _= substr($, j, 1)  /*process each character in  $  string.*/
       if @._==0  then do;   #= # + 1            /*Unique?  Yes, bump character counter.*/
                             $$= $$ || _         /*add this character to the  $$  list. */
                       end
       @._= @._ + 1                              /*keep track of this character's count.*/
       end   /*j*/
sum= 0                                           /*calculate info entropy for each char.*/
       do i=1  for #;        _= substr($$, i, 1) /*obtain a character from unique list. */
       sum= sum  -   @._/L * log2(@._/L)         /*add (negatively) the char entropies. */
       end   /*i*/
say ' input string: '   $
say 'string length: '   L
say ' unique chars: '   #;          say
say 'the information entropy of the string ──► '         format(sum,,12)          " bits."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
e: e= 2.718281828459045235360287471352662497757247093699959574966967627724076630; return e
/*──────────────────────────────────────────────────────────────────────────────────────*/
log2: procedure;  parse arg x 1 ox;     ig= x>1.5;     ii= 0;         is= 1 - 2 * (ig\==1)
      numeric digits digits()+5;        call e   /*the precision of E must be≥digits(). */
        do  while  ig & ox>1.5 | \ig&ox<.5;       _= e;       do j=-1;   iz= ox * _ ** -is
        if j>=0 & (ig & iz<1 | \ig&iz>.5)  then leave;    _= _ * _;    izz= iz;  end /*j*/
        ox=izz;  ii=ii+is*2**j;  end /*while*/;   x= x * e** -ii -1;   z= 0;  _= -1;  p= z
          do k=1;   _= -_ * x;   z= z+_/k;        if z=p  then leave;  p= z;    end  /*k*/
        r= z + ii;               if arg()==2  then return r;         return r / log2(2, .)
