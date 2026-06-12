# Output: a prn in range(0;$n) where $n is `.`
def prn:
  if . == 1 then 0
  else . as $n
  | ([1, (($n-1)|tostring|length)]|max) as $w
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

# The task:
[range(1;21)] | knuthShuffle
