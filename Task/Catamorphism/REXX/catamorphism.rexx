/*REXX pgm shows a method for  catamorphism  for some simple functions. */
@list = 1 2 3 4 5 6 7 8 9 10
                               say 'show:'  fold(@list, 'show')
                               say ' sum:'  fold(@list, '+')
                               say 'prod:'  fold(@list, '*')
                               say ' cat:'  fold(@list, '||')
                               say ' min:'  fold(@list, 'min')
                               say ' max:'  fold(@list, 'max')
                               say ' avg:'  fold(@list, 'avg')
                               say ' GCD:'  fold(@list, 'GCD')
                               say ' LCM:'  fold(@list, 'LCM')
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FOLD subroutine─────────────────────*/
fold: procedure;  parse arg z; arg ,f;   z=space(z)   /*F is uppercased.*/
za=translate(z, f, " ");     zf=f'('translate(z,',' ," ")')'
if f=='+'   | f=='*'    then interpret 'return' za
if f=='||'              then return space(z,0)
if f=='AVG'             then interpret 'return' fold(z,'+') "/" words(z)
if wordpos(f,'MIN MAX LCM GCD')\==0    then interpret 'return' zf
if f=='SHOW'            then return z
return 'illegal function:' arg(2)
/*──────────────────────────────────LCM subroutine──────────────────────*/
lcm:  procedure;  $=;                  do j=1  for arg(); $=$ arg(j);  end
x=abs(word($,1))                       /* [↑] build a list of arguments.*/
            do k=2  to words($);   !=abs(word($,k));  if !=0 then return 0
            x=x*! / gcd(x,!)           /*have  GCD do the heavy lifting.*/
            end   /*k*/
return x                               /*return with the money.         */
/*──────────────────────────────────GCD subroutine──────────────────────*/
gcd:  procedure;  $=;                  do j=1  for arg(); $=$ arg(j);  end
parse var $ x z .;   if x=0 then x=z   /* [↑] build a list of arguments.*/
x=abs(x)
            do k=2  to words($);    y=abs(word($,k));  if y=0 then iterate
              do until _==0;   _=x//y;   x=y;   y=_;   end   /*until*/
            end   /*k*/
return x                               /*return with the money.         */
