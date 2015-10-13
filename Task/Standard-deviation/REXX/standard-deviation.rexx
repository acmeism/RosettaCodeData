/*REXX pgm finds & displays the  standard deviation of a given set of numbers.*/
parse arg #                            /*any optional arguments on the C.L. ? */
if #=''  then  # = 2 4 4 4 5 5 7 9     /*None specified?  Then use the default*/
w=words(#);  L=length(w);  $=0;  $$=0  /*# items;  item width;  couple of sums*/
                                       /* [↓]  process each number in the list*/
     do j=1  for w;       _=word(#,j);     $=$+_;      $$=$$+_**2
     say  '   item'    right(j,L)":"  right(_,4)    '  average='   left($/j,12),
          '   standard deviation='    left(sqrt( $$/j - ($/j)**2 ), 15)
     end   /*j*/                       /* [↑]  prettify output with whitespace*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
      numeric digits 9; numeric form; h=d+6;  if x<0  then  do; x=-x; i='i'; end
      parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
         do j=0  while h>9;      m.j=h;              h=h%2+1;         end  /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;    end  /*k*/
      numeric digits d;     return (g/1)i            /*make complex if  X < 0.*/
