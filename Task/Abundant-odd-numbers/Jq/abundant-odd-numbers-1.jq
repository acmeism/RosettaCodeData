# The factors, unsorted
def factors:
  . as $num
  | reduce range(1; 1 + sqrt|floor) as $i
      ([];
       if ($num % $i) == 0 then
         ($num / $i) as $r
         | if $i == $r then . + [$i] else . + [$i, $r] end
       else .
       end) ;

def abundant_odd_numbers:
  range(1; infinite; 2)
  | (factors | add) as $sum
  | select($sum > 2*.)
  | [., $sum] ;
