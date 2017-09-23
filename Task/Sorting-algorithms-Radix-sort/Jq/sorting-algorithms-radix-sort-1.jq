# Sort the input array;
# "base" must be an integer greater than 1
def radix_sort(base):
  # We only need the ceiling of non-negatives:
  def ceil: if . == floor then . else (. + 1 | floor) end;

  min as $min
  | map(. - $min)
  | ((( max|log) / (base|log)) | ceil) as $rounds
  | reduce range(0; $rounds) as $i
      # state: [ base^i, buckets ]
      ( [1, .];
        .[0] as $base_i
        | reduce .[1][] as $n
            ([];
             (($n/$base_i) % base) as $digit
             | .[$digit] += [$n] )
        | [($base_i * base), (map(select(. != null)) | flatten)] )
  | .[1]
  | map(. + $min) ;

def radix_sort:
  radix_sort(10);
