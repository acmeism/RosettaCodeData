# Task parameters
def parameters: {
    N:         100000,
    NUM_BINS:  12,
    HIST_CHAR: "■",
    HIST_CHAR_ALT: "-",
    HIST_CHAR_SIZE: null,  # null means compute dynamically
    binSize:   0.1,
    mu:        0.5,
    sigma:     0.25 }
    | .bins = [range(0; .NUM_BINS) | 0] ;

# input: an array of two iid rvs on [0,1]
# output: [z0, z1] as per the Box-Muller method -- see
# https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
def normal(mu; sigma):
  def pi: (1|atan) * 4;
  . as [$u1, $u2]
  | pi as $pi
  | (sigma * ((-2 * ($u1|log))|sqrt)) as $mag
  | [ $mag * ((2 * $pi * $u2)|cos) + mu,
      $mag * ((2 * $pi * $u2)|sin) + mu ] ;

# Generate a random sample as specified by ., the task object (see `parameters`).
# Output: updated task object with sample statistics and .bins for creating a histogram.
# Each call to `input` should yield a string of random decimal digits
# such that the ensemble of ("0." + input | tonumber) can be considered to be iid rv on [0,1].
def generate:
  # uniformly distributed random variable on [0,1]:
  def udrv: "0." + input | tonumber;
  # Maybe compute the bucket size:
  (.HIST_CHAR_SIZE = (.HIST_CHAR_SIZE // (.N / (.NUM_BINS * 20) | ceil))) as $p
  | reduce range(0; $p.N/2) as $i ($p;
      ([udrv, udrv] | normal($p.mu; $p.sigma)) as $rns
      | reduce (0,1) as $j (.;
          $rns[$j] as $rn
	  | .n += 1
	  | .sum += $rn
	  | .ss  += ($rn*$rn)
          | (if $rn < 0 then 0
 	     elif $rn >= 1 then ($p.NUM_BINS - 1)
             else  ($rn/.binSize)|floor + 1
	     end ) as $bn
          | .bins[$bn] += 1
          # to retain the observations: .samples[$i*2 + $j] = $rn
	  )) ;

# Input: an object with
# {NUM_BINS, HIST_CHAR_SIZE, HIST_CHAR, HIST_CHAR_ALT, binSize, bins}
# Output: a stream of strings
def histogram:
  def tidy: pp(2;1);
  range(0; .NUM_BINS) as $i
  | ((.bins[$i] / .HIST_CHAR_SIZE)|floor) as $bs
  | (if $i == 0 or $i == .NUM_BINS -1
     then .HIST_CHAR_ALT else .HIST_CHAR end) as $char
  | (if $bs == 0 then "" else $char * $bs end) as $hist
  | if $i == 0
    then " -∞  ..< 0.0 \($hist)"    #   .bins[0]
    elif ($i < .NUM_BINS - 1)
    then "\(.binSize * ($i-1) | tidy) ..<\(.binSize * $i|tidy) \($hist)"  # .bins[$i]]
    else " 1.0 ..  +∞  \($hist)"    #   .bins[.NUM_BINS - 1]
    end;

def task:
  parameters
  | generate
  | sample_mean_and_variance
  | (if .HIST_CHAR_SIZE == 1 then "" else "s" end) as $plural
  | "Summary statistics for \(.N) observations from N(\(.mu), \(.sigma)):",
     "    mean:              \(.mean | pp(2;4))",
     "    variance:          \(.variance | pp(2;4))",
     "    unadjusted stddev: \(.variance | sqrt | pp(2;4))",
     "    Range               Number of observations (each \(.HIST_CHAR) represents \(.HIST_CHAR_SIZE) observation\($plural))",
     histogram ;

task
