#def squares: range(1; infinite) | . * .;

# sums of distinct squares (sods)
# Output: a stream of [$n, $sums] where $sums is the array of sods based on $n
def sods:
  # input: [$n, $sums]
  def next:
    . as [$n, $sums]
    | (($n+1)*($n+1)) as $next
    | reduce $sums[] as $s ($sums + [$next];
        if index($s + $next) then . else . + [$s + $next] end)
    | [$n + 1, unique];

  [1, [1]]
  | recurse(next);

# Input: an array
# Output: the length of the run beginning at $n
def length_of_run($n):
  label $out
  | (range($n+1; length),null) as $i
  | if $i == null then (length-$n)
    elif .[$i] == .[$i-1] + 1 then empty
    else $i-$n, break $out
    end;

# Input: an array
def length_of_longest_run:
  . as $in
  | first(
      foreach (range(0; length),null) as $i (0;
        if $i == null then .
        else ($in|length_of_run($i)) as $n
        | if $n > . then $n else . end
        end;
        if $i == null or (($in|length) - $i) < . then . else empty end) );

def sq: .*.;

# Output: [$ix, $length]
def relevant_sods:
  first(
    sods
    | . as [$n, $s]
    | ($s|length_of_longest_run) as $length
    | if $length > ($n+1|sq) then . else empty end );

def not_sum_of_distinct_squares:
  relevant_sods
  | . as [$ix, $sods]
  | [range(2; $ix+2|sq)] - $sods;

not_sum_of_distinct_squares
