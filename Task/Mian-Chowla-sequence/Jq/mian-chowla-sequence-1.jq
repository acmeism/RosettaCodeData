# Input: a bag-of-words (bow)
# Output: either an augmented bow, or nothing if a duplicate is found
def augment_while_unique(stream):
  label $out
  | foreach ((stream|tostring), null) as $word (.;
       if $word == null then .
       elif has($word) then break $out
       else .[$word] = 1
       end;
      select($word == null) );

# For speedup, store "sums" as a hash
def mian_chowlas:
  {m:[1], sums: {"1":1}}
  | recurse(
      .m as $m
      | .sums as $sums
      | first(range(1+$m[-1]; infinite) as $i
	      | $sums
	      | augment_while_unique( ($m[] | (.+$i)), (2*$i))
	      | [$i, .] ) as [$i, $sums]
      | {m: ($m + [$i]), $sums} )
  | .m[-1] ;
