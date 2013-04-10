/*REXX pgm finds the averages/arithmetic mean of several lists (vectors)*/
@.1 =  10 9 8 7 6 5 4 3 2 1
@.2 =  10 9 8 7 6 5 4 3 2 1 0 0 0 0 .11
@.3 = '10 20 30 40 50 -100 4.7 -11e2'
@.4 = '1 2 3 4 five 6 7 8 9 10.1. ±2'
@.5 = 'World War I & World War II'
@.6 = ''
            do j=1  for 6
            say  'numbers = '  @.j;    say  'average = '  avg(@.j);    say
            end   /*t*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────AVG subroutine──────────────────────*/
avg:  procedure;         parse arg x;    w=words(x);  s=0;   $=left('',20)
if w==0 then return 'N/A: ───[null vector.]'
                 do k=1  for w;          _=word(x,k)
                 if datatype(_,'N') then do;  s=s+_;  iterate;  end
                 say $ '***error!*** non-numeric: ' _;  w=w-1 /*adjust W*/
                 end   /*k*/
if w==0 then return 'N/A: ───[no numeric values.]'
return s/max(1,w)
