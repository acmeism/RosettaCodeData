# The log (base e) of a Hamming triple:
def ln_hamming:
  if length != 3 then error("ln_hamming: \(.)") else . end
  | (.[0] * (2|log)) + (.[1] * (3|log)) + (.[2] * (5|log));

# The numeric value of a Hamming triple:
def hamming_tof: ln_hamming | exp;

def hamming_toi:
  def pow(n): . as $in | reduce range(0;n) as $i (1; . * $in);
  . as $in | (2|pow($in[0])) * (3|pow($in[1])) * (5|pow($in[2]));

# Return the index in the input array of the min_by(f) value
def index_min_by(f):
  . as $in
  | if length == 0 then null
    else .[0] as $first
    | reduce range(0; length) as $i
        ([0, $first, ($first|f)];   # state: [ix; min; f|min]
         ($in[$i]|f) as $v
         | if $v < .[2] then [ $i, $in[$i], $v ] else . end)
    | .[0]
    end;

# Emit n Hamming numbers (as triples) if n>0; the nth if n<0; otherwise indefinitely.
def hamming(n):

  # n must be 2, 3 or 5
  def hamming_times(n): n as $n
    | if $n==2 then .[0] += 1 elif $n==3 then .[1] += 1 else .[2] += 1 end;

  # input: [twos, threes, fives] of which at least one is assumed to be non-empty
  # output: the index of the array holding the min of the firsts
  def next: map( .[0] ) | index_min_by( ln_hamming );

  # input: [value, [twos, threes, fives] ....]
  # ix is the index in [twos, threes, fives] of the array to be popped
  # output: [popped, updated_arrays ...]
  def pop(ix):
    .[1] as $triple
    | setpath([0];    $triple[ix][0])
    | setpath([1,ix]; $triple[ix][1:]);

  # input: [x, [twos, threes, fives], count]
  # push value*2 to twos, value*3 to threes, value*5 to fives and increment count
  def push(v):
    [.[0], [.[1][0] + [v|hamming_times(2)], .[1][1] + [v|hamming_times(3)],
            .[1][2] + [v|hamming_times(5)]], .[2] + 1];

  # _hamming is the workhorse
  # input: [previous, [twos, threes, fives], count]
  def _hamming:
    .[0] as $previous
    | if (n > 0 and .[2] == n) or (n<0 and .[2] == -n) then $previous
      else (.[1]|next) as $ix     # $ix cannot be null
      | pop($ix)
      | .[0] as $next
      | (if $next == $previous then empty elif n>=0 then $previous else empty end),
        (if $next == $previous then . else push($next) end | _hamming)
      end;
  [[0,0,0], [ [[1,0,0]] ,[[0,1,0]], [[0,0,1]] ], 1] | _hamming;
