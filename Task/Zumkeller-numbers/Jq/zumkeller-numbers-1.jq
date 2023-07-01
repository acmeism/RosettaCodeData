# The factors, sorted
def factors:
  . as $num
  | reduce range(1; 1 + sqrt|floor) as $i
      ([];
       if ($num % $i) == 0 then
         ($num / $i) as $r
         | if $i == $r then . + [$i] else . + [$i, $r] end
       else .
       end
       | sort) ;

# If the input is a sorted array of distinct non-negative integers,
# then the output will be a stream of [$x,$y] arrays,
# where $x and $y are non-empty arrays that partition the
# input, and where ($x|add) == $sum.
# If [$x,$y] is emitted, then [$y,$x] will not also be emitted.
# The items in $x appear in the same order as in the input, and similarly
# for $y.
#
def distinct_partitions($sum):
  # input: [$array, $n, $lim] where $n>0
  # output: a stream of arrays, $a, each with $n distinct items from $array,
  #         preserving the order in $array, and such that
  #         add == $lim
  def p:
     . as [$in, $n, $lim]
     | if $n==1  # this condition is very common so it saves time to check early on
       then ($in | bsearch($lim)) as $ix
       | if $ix < 0 then empty
         else [$lim]
         end
       else ($in|length) as $length
       | if $length <= $n then empty
         elif $length==$n            then $in | select(add == $lim)
         elif ($in[-$n:]|add) < $lim then empty
         else  ($in[:$n]|add) as $rsum
         | if $rsum > $lim      then empty
           elif $rsum == $lim   then "amazing" | debug | $in[:$n]
           else range(0; 1 + $length - $n) as $i
           | [$in[$i]] + ([$in[$i+1:], $n-1, $lim - $in[$i]]|p)
           end
         end
       end;

  range(1; (1+length)/2) as $i
  | ([., $i, $sum]|p) as $pi
  | [ $pi, (. - $pi)]
  | select( if (.[0]|length) == (.[1]|length) then (.[0] < .[1]) else true end) #1
  ;

def zumkellerPartitions:
  factors
  | add as $sum
  | if $sum % 2 == 1 then empty
    else distinct_partitions($sum / 2)
    end;

def is_zumkeller:
  first(factors
        | add as $sum
        | if $sum % 2 == 1 then empty
          else distinct_partitions($sum / 2)
	  | select( (.[0]|add) == (.[1]|add)) // ("internal error: \(.)" | debug | empty)  #2
	  end
	| true)
  // false;
