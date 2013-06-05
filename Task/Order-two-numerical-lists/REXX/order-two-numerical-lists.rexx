/*REXX pgm finds if list1<list2 (both contain nums), returns true|false.*/
@.=
@.1=1 2 1 5 2
@.2=1 2 1 5 2 2
@.3=1 2 3 4 5
@.4=1 2 3 4 5
                  do i=2  while  @.i\=='';    m=i-1
                  what=' 'word("< ≥", 1+(FNorder(@.m, @.i)=='false'))" "
                  say  right('['@.m"]", 35)   what   '['@.i"]";        say
                  end   /*i*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FNORDER subroutine──────────────────*/
FNorder:  procedure;  parse arg x,y;      wx=words(x);         wy=words(y)

                                do j=1  for min(wx,wy)
                                if word(x,j)<word(y,j)  then return 'true'
                                end   /*j*/
if wx<wy  then return 'true'
               return 'false'
