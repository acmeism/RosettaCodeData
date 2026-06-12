def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def is_strange:
  def sum($i): (.[$i:$i+1]|tonumber) + (.[$i+1:$i+2]|tonumber);
  tostring
  | length > 2 and (sum(0) | is_prime) and  (sum(1) | is_prime) ;

def task:
  [range(101; 500)
   | select(is_strange)]
  | nwise(10)
  | join(" ");

task
