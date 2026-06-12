# Input: an array representing a configuration of one or more lanterns.
# Output: the number of distinct ways to lower them.
def lanterns:

  def organize: map(select(. > 0)) | sort;

  # input and output: {cache, count}
  def n($array):
    ($array | organize) as $organized
    |  ($organized|length) as $length
    | if   $length == 1 then .count = 1
      elif $length == 2 and $organized[0] == 1 then .count = ($organized | add)
      else .cache[$organized|tostring] as $n
      | if $n then .count = $n
        else reduce range(0; $length) as $i ({cache, count: 0, a : $organized};
            .a[$i] += -1
            | .a as $new
            | n($new) as {count: $count, cache: $cache}
            | .count += $count
            | .cache = ($cache | .[$new | tostring] = $count)
            | .a[$i] += 1 )
        | {cache, count}
        end
      end;
  . as $a | null | n($a) | .count;

"Lantern configuration => number of permutations",
([1,3,3],
 [100,2],
 (range(2; 10) as $nlanterns
 | [range(1; $nlanterns)])
 | "\(.) => \(lanterns)" )
