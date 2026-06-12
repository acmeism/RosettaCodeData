# Output: a stream of prn in range(0;$n) where $n is . and $n > 1
def prns:
  . as $n
  | (($n-1)|tostring|length) as $w
  # Output: a prn in range(0;$n)
  | def prn:
      [limit($w; inputs)] | join("") | tonumber
      | if . < $n then . else prn end;
  repeat(prn);

# Output: a prn in range(0;$n) where $n is .,
# b
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def sattoloCycle:
  length as $n
  | if $n ==0 then []
    elif $n == 1 then empty   # a Sattolo cycle is not possible
    else {i: $n, a: .}
    | until(.i ==  1;         # n.b.
        .i += -1
        | (.i | prn) as $j    # this line distinguishes the Sattolo cycle from the Knuth shuffle
        | .a[.i] as $t
        | .a[.i] = .a[$j]
        | .a[$j] = $t)
    | .a
    end;

def task:
  [],
  [10,20],
  [10,20,30],
  [range(11;23)]
  | sattoloCycle;

task
