### Preliminaries
# _nwise/1 is included here for the sake of gojq:
def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def tobase($b):
  def digit: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[.:.+1];
  def mod: . % $b;
  def div: ((. - mod) / $b);
  def digits: recurse( select(. > 0) | div) | mod ;
  # For jq it would be wise to protect against `infinite` as input, but using `isinfinite` confuses gojq
  select( (tostring|test("^[0-9]+$")) and 2 <= $b and $b <= 36)
  | if . == 0 then "0"
    else [digits | digit] | reverse[1:] | add
    end;

### Esthetic Numbers
def isEsthetic($b):
  if . == 0 then false
  else {i: (. % $b), n: ((./$b)|floor) }
  | until (.n <= 0;
      (.n % $b) as $j
      | if (.i - $j)|length != 1  # abs
        then .n = -1 #flag
        else .n |= ((./$b)|floor)
        | .i = $j
        end)
  | .n != -1
  end;

# depth-first search
# input: {esths}
def dfs($n; $m; $i):
  if ($i >= $n and $i <= $m) then .esths += [$i] else . end
  | if ($i == 0 or $i > $m) then .
    else ($i % 10) as $d
    | ($i*10 + $d - 1) as $i1
    | ($i1 + 2) as $i2
    | if $d == 0
      then dfs($n; $m; $i2)
      elif $d == 9
      then dfs($n; $m; $i1)
      else dfs($n; $m; $i1) | dfs($n; $m; $i2)
      end
    end;

### The tasks
def listEsths(n; n2; m; m2; $perLine; $all):
  ( {esths: []}
    | reduce range(0;10) as $i (.; dfs(n2; m2; $i) )
    | "Base 10: \(.esths|length) esthetic numbers between \(n) and \(m)",
      if $all
      then .esths | _nwise($perLine) | join(" ")
      else
        (.esths[:$perLine] | join(" ")),
        "............",
        (.esths[-$perLine:] | join(" "))
      end ),
    "";

def task($maxBase):
  range (2; 1+$maxBase) as $b
  | "Base \($b): \(4*$b)th to \(6*$b)th esthetic numbers:",
    ( [{ n: 1, c: 0 }
       | while (.c <= 6*$b;
           .emit = null
           | if (.n|isEsthetic($b))
             then .c += 1
             | if .c >= 4*$b
               then .emit = "\(.n | tobase($b))"
               else .
               end
             else .
             end
        | .n += 1 )
      | select(.emit).emit]
    | _nwise(10) | join(" ") ),
  "" ;

task(16),

# the following all use the obvious range limitations for the numbers in question
listEsths(1000;            1010;    9999;            9898; 16; true),
listEsths(1e8;        101010101;  13*1e7;       123456789;  9; true),
listEsths(1e11;    101010101010; 13*1e10;    123456789898;  7; false),
listEsths(1e14; 101010101010101; 13*1e13; 123456789898989;  5; false)
