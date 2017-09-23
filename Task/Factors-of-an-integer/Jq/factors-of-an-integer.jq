# This implementation uses "sort" for tidiness
def factors:
  . as $num
  | reduce range(1; 1 + sqrt|floor) as $i
      ([];
       if ($num % $i) == 0 then
         ($num / $i) as $r
         | if $i == $r then . + [$i] else . + [$i, $r] end
       else .
       end )
  | sort;

def task:
  (45, 53, 64) | "\(.): \(factors)" ;

task
