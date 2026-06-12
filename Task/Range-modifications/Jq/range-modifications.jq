# Conversion between string and JSON representations of ranges
# Allow negative integers
def r2j:
  [ scan( "(-?[0-9]+)-(-?[0-9]+)|(-?[0-9]+)" )
    | map(select(. != null) | tonumber)
    | if length==1 then [first,first] end ] ;

def j2r:
  map( if first == last then "\(first)"
       else "\(first)-\(last)"
       end )
  | join(",");

# A quick determination of whether $n is in a sequence of intervals
def indexOf($n):
  (first( range(0;length) as $i
         | if .[$i][0] <= $n and $n <= .[$i][1] then $i
           elif $n < .[$i][0] then -1
           else empty
           end ) // -1)
  | if . == -1 then null else . end ;

def rangesAdd($n):

  # Detect the special case where $i is the only integer in the gap between .[$i] and .[$i+1]
  def tween($i):
    -1 < $i and $i < length - 1 and .[$i][1] == $i - 1 and .[$i+1][0] == $i + 1;

  # First handle the boundary cases:
  if length == 0 then [[$n, $n]]
  elif $n  < .[0][0]-1 then [[$n,$n]] + .
  elif $n == .[0][0]-1 then [[$n, .[0][1]]] + .[1:]
  elif $n  > .[-1][1]+1 then . + [[$n,$n]]
  elif $n == .[-1][1]+1 then .[:-1] + [[.[-1][0], $n]]
  else (map(first) | bsearch($n)) as $ix
  | if $ix >= 0 then .
    else (-2-$ix) as $i  # $i >= 0 is the interval at the insertion point minus 1
    | if tween($i)
      then .[:$i] + [[.[$i][0], .[$i+1][1]]] + .[$i+2:]                # coalesce
      else .[$i] as $x              # the preliminary checks above ensure 0 <= $i < $length-1
      | if $x[0] <= $n and $n <= $x[1]                                              # [_ $n _]
        then .
        elif $n == $x[1] + 1                                                        # [ *] $n
        then (if $i == 0 then null else .[$i-1:] end) + [[$x[0], $n]] + .[$i+1:]
        elif $n == .[$i+1][0] - 1                                                   # $n [* _]
        then .[:$i+1] + [[$n, .[$i+1][1]]] + .[$i+2:]
        else # assert($x[1] < $n and $n < .[$i+1][0])                               # [] $n []
             .[:$i+1] + [[$n,$n]] + .[$i+1:]
        end
      end
    end
  end ;

def rangesRemove($n):
  # remove a value from a single interval
  def remove($n):
    . as [$a,$b]
    | if $a == $b and $a == $n then null
      elif $a == $n then [[$n+1, $b]]
      elif $b == $n then [[$a, $n-1]]
      else [[$a, $n-1], [$n+1, $b]]
      end;

  indexOf($n) as $ix
  | if $ix then .[:$ix] + (.[$ix]|remove($n)) + .[$ix+1:]
    else .
    end ;

### Pretty printing
def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# Functions for showing intermediate results, in string form:
# Input: the JSON representation
def add(n):
  rangesAdd(n)
  | debug("    add \(n|lpad(3)) => \(j2r)");

def remove(n):
  rangesRemove(n)
  | debug(" remove \(n|lpad(3)) => \(j2r)");

# The tasks expressed as sequences of operations on the JSON representation
def s0:
  add(77)
  | add(79)
  | add(78)
  | remove(77)
  | remove(78)
  | remove(79)
;

def s1:
  add(1)
  | remove(4)
  | add(7)
  | add(8)
  | add(6)
  | remove(7)
;

def s2:
  add(26)
  | add(9)
  | add(7)
  | remove(26)
  | remove(9)
  | remove(7)
;

def ex0: "Starting with \(.)", "Ending with \(r2j | s0 | j2r)\n";
def ex1: "Starting with \(.)", "Ending with \(r2j | s1 | j2r)\n";
def ex2: "Starting with \(.)", "Ending with \(r2j | s2 | j2r)\n";

(""      | ex0),
("1-3,5" | ex1),
("1-5,10-25,27-30" | ex2)
