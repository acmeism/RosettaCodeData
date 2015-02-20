@verb #100:sum_squares this none this rd
@program #100:sum_squares
sum = 0;
list = args[1];
for i in (list)
  sum = sum + (i^2);
endfor
player:tell(toliteral(list), " => ", sum);
.

{{out}}
;#100:sum_squares({3,1,4,1,5,9})
{3, 1, 4, 1, 5, 9} => 133
;#100:sum_squares({})
{} => 0
