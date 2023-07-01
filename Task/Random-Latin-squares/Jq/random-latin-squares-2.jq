'''Generic Utility Functions'''
# For inclusion using jq's `include` directive:
# Output: a PRN in range(0;$n) where $n is .
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def knuthShuffle:
  length as $n
  | if $n <= 1 then .
    else {i: $n, a: .}
    | until(.i ==  0;
        .i += -1
        | (.i + 1 | prn) as $j
        | .a[.i] as $t
        | .a[.i] = .a[$j]
        | .a[$j] = $t)
    | .a
    end;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# If the input array is not rectangular, let nulls fall where they may
def column($j):
   [.[] | .[$j]];

# Emit a stream of [value, frequency] pairs
def histogram(stream):
  reduce stream as $s ({};
    ($s|type) as $t
     | (if $t == "string" then $s else ($s|tojson) end) as $y
     | .[$t][$y][0] = $s
     | .[$t][$y][1] += 1 )
  | .[][] ;

def ss(s): reduce s as $x (0; . + ($x * $x));

def chiSquared($expected): ss( .[] - $expected ) / $expected;
