def normalize_base($base):
  def n:
    if length == 1 and .[0] < $base then .[0]
    else .[0] % $base,
           ((.[0] / $base|floor) as $carry
            |.[1:]
	    | .[0] += $carry
            | n )
    end;
   n;

def integers_as_arrays_times($n; $base):
  map(. * $n)
  | [normalize_base($base)];


def p($L; $n):
  # @assert($L > 0 and $n > 0)
  ($L|tostring|explode|reverse|map(. - 48)) as $digits   # "0" is 48
  | ($digits|length) as $ndigits
  | (2*(2+($n|log|floor))) as $extra
  | { m: $n,
      i: 0,
      keep: ( 2*(2+$ndigits) + $extra),
      p: [1] # reverse-array representation of 1
    }
  | until(.m == 0;
           .i += 1
         | .p |= integers_as_arrays_times(2; 10)
	 | .p = .p[ -(.keep) :]
         | if (.p[-$ndigits:]) == $digits
           then
           | .m += -1  | .keep -= ($extra/$n)
	   else . end )
  | .i;

## The task
[[12, 1], [12, 2], [123, 45], [123, 12345], [123, 678910]][]
| "With L = \(.[0]) and n = \(.[1]), p(L, n) = \( p(.[0]; .[1]))"
