# Emit the k-th smallest item in the input array,
# or nothing if k is too small or too large.
# The smallest corresponds to k==1.
# The input array may hold arbitrary JSON entities, including null.
def quickselect(k):

  def partition(pivot):
    reduce .[] as $x
      # state: [less, other]
      ( [ [], [] ];                       # two empty arrays:
        if    $x  < pivot
        then .[0] += [$x]                 # add x to less
        else .[1] += [$x]                 # add x to other
        end
      );

  # recursive inner function has arity 0 for efficiency
  def qs:  # state: [kn, array] where kn counts from 0
    .[0] as $kn
     | .[1] as $a
    | $a[0] as $pivot
    | ($a[1:] | partition($pivot)) as $p
    | $p[0] as $left
    | ($left|length) as $ll
    | if   $kn == $ll then $pivot
      elif $kn <  $ll then [$kn, $left] | qs
      else [$kn - $ll - 1, $p[1] ] | qs
      end;

  if length < k or k <= 0 then empty else [k-1, .] | qs end;
