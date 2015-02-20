/*REXX pgm determines if a list < previous list,  & returns true | false*/
@.  =
@.1 = 1 2 1 5 2
@.2 = 1 2 1 5 2 2
@.3 = 1 2 3 4 5
@.4 = 1 2 3 4 5                        /* [↓]  compare list to previous.*/
                do j=2  while  @.j\=='';    p=j-1   /*P is the previous.*/
                answer=FNorder(@.p, @.j)            /*obtain the answer.*/
                if answer=='true'  then is= ' < '   /*convert from true */
                                   else is= ' ≥ '   /*convert from false*/
                say  right('['@.p"]", 40)       is     '['@.j"]";      say
                end   /*i*/            /* [↑]  display  (+ a blank line)*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FNORDER subroutine──────────────────*/
FNorder:  procedure;  parse arg x,y;          wx=words(x);  wy=words(y)

                                do k=1  for min(wx,wy)
                                a=word(x,k);  b=word(y,k)
                                if a<b  then                return 'true'
                                        else  if a>b  then  return 'false'
                                end   /*k*/
if wx<wy  then return 'true'
               return 'false'
