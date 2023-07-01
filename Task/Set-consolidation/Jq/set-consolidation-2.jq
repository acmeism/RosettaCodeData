# Input: [i, j, sets] with i < j
# Return [i,j] for a pair that can be combined, else null
def combinable:
   .[0] as $i | .[1] as $j | .[2] as $sets
   | ($sets|length) as $length
   | if intersect($sets[$i]; $sets[$j]) then [$i, $j]
     elif $i < $j - 1      then (.[0] += 1 | combinable)
     elif $j < $length - 1 then [0, $j+1, $sets] | combinable
     else null
     end;

# Given an array of arrays, remove the i-th and j-th elements,
# and add their union:
def update(i;j):
  if i > j then update(j;i)
  elif i == j then del(.[i])
  else
    union(.[i]; .[j]) as $c
    | union(del(.[j]) | del(.[i]); [$c])
  end;

# Input: a set of sets
def consolidate:
   if length <= 1 then .
   else
     ([0, 1, .] | combinable) as $c
     | if $c then update($c[0]; $c[1]) | consolidate
       else .
       end
   end;
