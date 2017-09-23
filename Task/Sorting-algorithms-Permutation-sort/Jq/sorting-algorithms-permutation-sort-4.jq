def permutation_sort:
  # emit the first item in stream that satisfies the condition
  def first(stream; cond):
     label $out
     | foreach stream as $item
         ( [false, null];
           if .[0] then break $out else [($item | cond), $item] end;
           if .[0] then .[1] else empty end );
  first(permutations; sorted);
