# "first" is the first triple, e.g. [1,a,b];
# "count" specifies the number of terms to use.
def continued_fraction( first; next; count ):
  # input: [i, a, b]
  def cf:
      if .[0] == count then 0
      else next as $ab
      | .[1] + (.[2] / ($ab | cf))
      end ;
  first | cf;

# "first" and "next" are as above;
# if delta is 0 then continue until there is no detectable change.
def continued_fraction_delta(first; next; delta):
  def abs: if . < 0 then -. else . end;
  def cf:
    # state: [n, prev]
    .[0] as $n | .[1] as $prev
    |  continued_fraction(first; next; $n+1) as $this
    | if $prev == null then [$n+1, $this] | cf
      elif delta <= 0 and ($prev == $this) then $this
      elif (($prev - $this)|abs) <= delta then $this
      else [$n+1, $this] | cf
      end;
  [2,null] | cf;
