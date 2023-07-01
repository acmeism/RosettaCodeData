def is_prime:
  . as $n
  | if ($n < 2)         then false
    elif ($n % 2 == 0)  then $n == 2
    elif ($n % 3 == 0)  then $n == 3
    elif ($n % 5 == 0)  then $n == 5
    elif ($n % 7 == 0)  then $n == 7
    elif ($n % 11 == 0) then $n == 11
    elif ($n % 13 == 0) then $n == 13
    elif ($n % 17 == 0) then $n == 17
    elif ($n % 19 == 0) then $n == 19
    else {i:23}
         | until( (.i * .i) > $n or ($n % .i == 0); .i += 2)
	 | .i * .i > $n
    end;

# pretty-printing
def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def table($ncols; $colwidth):
  nwise($ncols) | map(lpad($colwidth)) | join(" ");
