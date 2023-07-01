# If A and B are sets, then intersection(A;B) emits their intersection:
def intersection($A;$B):
  def pop:
    .[0] as $i
    | .[1] as $j
    | if $i == ($A|length) or $j == ($B|length) then empty
      elif $A[$i] == $B[$j] then $A[$i], ([$i+1, $j+1] | pop)
      elif $A[$i] <  $B[$j] then [$i+1, $j] | pop
      else [$i, $j+1] | pop
      end;
  [[0,0] | pop];
