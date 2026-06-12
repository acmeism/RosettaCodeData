# 0 <= output < $n
def rand($n):

  def ntimes(f): range(0; .) | f;

  # input: an array of length ($n|tostring|length)
  def r:
    . as $in
    | (join("") | tonumber) as $m
    | if $m < $n then $m
      else $in[1:] + [input] | r
      end;
  [$n | tostring | length | ntimes(input)] | r;

# $n specifies the number of iterations
def task($n):
  (reduce range(1; $n + 1) as $trial (null;
    .sbeh = 0
    | .slen = 100
    | .secs = 0
    | until (.sbeh >= .slen;
        .sbeh += 1
        | reduce range(1;6) as $wiz (.;
            if (rand( .slen) < .sbeh) then .sbeh += 1 else . end
            | .slen += 1 )
        | .secs += 1
        | if ($trial == 1 and .secs > 599 and .secs < 610)
          then  ([.secs, .sbeh, .slen - .sbeh] | debug) as $debug | .
          else .
          end )
    | .totalSecs  += .secs
    | .totalSteps += .slen ) ) ;

"Seconds    steps behind    steps ahead",
"-------    ------------    -----------",
(1E4 as $n
| task($n)
| "\nAverage secs taken over \($n) trials: \(.totalSecs/$n)",
  "Average final length of staircase: \(.totalSteps/$n)"
)
