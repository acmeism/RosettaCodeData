def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def task:
  def pp: if . >=0 then " \(.)" else tostring end;
  (199 | mobius_array) as $mu
  | "The first 199 Möbius numbers are:",
    (["  ", (range(1; 200) | $mu[.] | pp )]
     | nwise(20)
     | join(" ") ) ;

task
