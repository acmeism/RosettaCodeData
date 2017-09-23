# ordinalize an integer input, positive or negative
def ordinalize:
 (if . < 0 then -(.) else . end) as $num
 | ($num % 100) as $small
 | (if 11 <= $small and $small <= 13 then "th"
    else
    ( $num % 10)
      | (if   . == 1 then "st"
         elif . == 2 then "nd"
         elif . == 3 then "rd"
         else             "th"
         end)
    end) as $ordinal
 | "\(.)\($ordinal)" ;

([range(-5; -1)], [range(0;26)], [range(250;266)], [range(1000;1026)])
 | map(ordinalize)
