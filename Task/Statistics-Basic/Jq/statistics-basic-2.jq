  # $histogram should be a JSON object, with buckets as keys and frequencies as values;
  # $keys should be an array of all the potential bucket names (possibly integers)
  # in the order to be used for display:
  def pp($histogram; $keys):
    ([$histogram[]] | add) as $n  # for scaling
    | ($keys|length) as $length
    | $keys[]
    | "\(.) : \("*" * (($histogram[tostring] // 0) * 20 * $length / $n) // "" )" ;

  # `basic_stats` computes the unadjusted standard deviation
  # and assumes the sum of squares (ss) can be computed without concern for overflow.
  # The histogram is based on allocation to a bucket, which is made
  # using `bucketize`, e.g. `.*10|floor`
  def basic_stats(stream; bucketize):
    # Use
    reduce stream as $x ({histogram: {}};
      .count += 1
      | .sum += $x
      | .ss  += $x * $x
      | ($x | bucketize | tostring) as $bucket
      | .histogram[$bucket] += 1 )
    | .mean = (.sum / .count)
    | .stddev = (((.ss/.count) - .mean*.mean) | sqrt) ;

  basic_stats( "0." + inputs | tonumber; .*10|floor)
  | "

Basic statistics for \(.count) PRNs in [0,1]:
mean:   \(.mean)
stddev: \(.stddev)
Histogram dividing [0,1] into 10 equal intervals:",
    pp(.histogram; [range(0;10)] )
