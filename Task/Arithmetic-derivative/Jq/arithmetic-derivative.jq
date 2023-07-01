To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# In case gojq is used:
def _nwise($n):
  def nw: if length <= $n then . else .[0:$n] , (.[$n:] | nw) end;
  nw;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def D($n):
    if   $n < 0 then -D(- $n)
    elif $n < 2 then 0
    else [$n | factors] as $f
    | ($f|length) as $c
    | if   $c <= 1 then 1
      elif $c == 2 then $f[0] + $f[1]
      else ($n / $f[0]) as $d
      | D($d) * $f[0] + $d
      end
    end ;

def task:
  def task1:
    reduce range(-99; 101) as $n ([]; .[$n+99] = D($n))
    | _nwise(10) | map(lpad(4)) | join(" ");

  def task2:
    range(1; 21) as $i
    | "D(10^\($i)) / 7 = \( D(10|power($i))/7 )" ;

  task1, "", task2 ;

task
