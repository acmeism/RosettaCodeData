def terminus:
  # sum of the squared digits
  def ssdigits: tostring | explode | map(. - 48 | .*.) | add;

  if . == 1 or . == 89 then .
  else ssdigits | terminus
  end;

# Count the number of integers i in [1... 10^D] with terminus equal to 89.
def task(D):
  # The max sum of squares is D*81 so return an array that will instantly
  # reveal whether n|terminus is 89:
  def cache:
    reduce range(1; D*81+1) as $d ([false]; . + [$d|terminus == 89]);

  # Compute n / (i1! * i2! * ... ) for the given combination,
  # which is assumed to be in order:
  def combinations(n):
    runs | map( .[1] | factorial) | reduce .[] as $i (n; ./$i);

  cache as $cache
  | (D|factorial) as $Dfactorial
  | reduce ([range(0;10)] | pick(D)) as $digits
      (0;
       ($digits | map(.*.) | add) as $ss
       | if $cache[$ss] then . + ($digits|combinations($Dfactorial))
         else .
         end) ;
