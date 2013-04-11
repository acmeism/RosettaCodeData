/*REXX program to find the standard deviation of a given set of numbers.*/
parse arg #                            /*let the user specify numbers.  */
if #=''  then #=2 4 4 4 5 5 7 9        /*None given?   Then use default.*/
w=words(#);  s=0;  ss=0                /*define: #items, a couple sums. */

            do j=1  for w;   _=word(#,j);   s=s+_;   ss=ss+_*_
            say  '   item'  right(j,length(w))":"  right(_,4),
                 '   average=' left(s/j,12),
                 '   standard deviation=' left(sqrt( ss/j - (s/j)**2 ),15)
            end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SQRT subroutine─────────────────────*/
sqrt:   procedure;parse arg x; if x=0 then return 0; d=digits(); numeric digits 11; g=.sqrtGuess()
        do j=0 while p>9; m.j=p; p=p%2+1; end; do k=j+5 to 0 by -1; if m.k>11 then numeric digits m.k
        g=.5*(g+x/g); end; numeric digits d; return g/1
.sqrtGuess: numeric form;  m.=11;  p=d+d%4+2
        parse value format(x,2,1,,0) 'E0' with g 'E' _ .; return g*.5'E'_%2
