def is_harshad:
 def digits: tostring | [explode[] | ([.]| implode) | tonumber];
 if . >= 1 then (. % (digits|add)) == 0
 else false
 end ;

# produce a stream of n Harshad numbers
def harshads(n):
  # [candidate, count]
  def _harshads:
    if .[0]|is_harshad then .[0], ([.[0]+1, .[1]-1]| _harshads)
    elif .[1] > 0 then [.[0]+1, .[1]] | _harshads
    else empty
    end;
  [1, n] | _harshads ;

# First Harshad greater than n where n >= 0
def harshad_greater_than(n):
  # input: next candidate
  def _harshad:
    if is_harshad then .
    else .+1 | _harshad
    end;
  (n+1) | _harshad ;

# Task:
[ harshads(20), "...", harshad_greater_than(1000)]
