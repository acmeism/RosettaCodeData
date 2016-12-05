# Generate a single number following the normal distribution with mean 0, variance 1,
# using the Box-Muller method: X = sqrt(-2 ln U) * cos(2 pi V) where U and V are uniform on [0,1].
# Input: [n, state]
# Output [n+1, nextstate, r]
def next_rand_normal:
  def u: next_rand_Microsoft | .[2] /= 32767;
  u as $u1
  | ($u1 | u) as $u2
  | ((( (8*(1|atan)) * $u1[2]) | cos)
     * ((-2 * (($u2[2]) | log)) | sqrt)) as $r
  | [ (.[0]+1), $u2[1], $r] ;

# Generate "count" arrays, each containing a random normal variate with the given mean and standard deviation.
# Input: [count, state]
# Output: [updatedcount, updatedstate, rnv]
# where "state" is a seed and "updatedstate" can be used as a seed.
def random_normal_variate(mean; sd; count):
  next_rand_normal
  | recurse( if .[0] < count then next_rand_normal else empty end)
  | .[2] = (.[2] * sd) + mean;
