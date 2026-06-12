# unordered
def proper_divisors:
  . as $n
  | if $n > 1 then 1,
      ( range(2; 1 + (sqrt|floor)) as $i
        | if ($n % $i) == 0 then $i,
            (($n / $i) | if . == $i then empty else . end)
         else empty
	 end)
    else empty
    end;

# Uses the first definition and recursion to generate the sequences.
def moreMultiples($toSeq; $fromSeq):
    reduce $fromSeq[] as $i ({oneMores: []};
        if ($i > $toSeq[-1]) and ($i % $toSeq[-1]) == 0
	then .oneMores += [$toSeq + [$i]]
	else .
	end)
    | reduce range(0; .oneMores|length) as $i (.;
        .oneMores += moreMultiples(.oneMores[$i]; $fromSeq) )
    | .oneMores ;

# Input: {cache, ...}
# Output: {cache, count, ... }
def erdosFactorCount($n):
  def properDivisors: proper_divisors | select(. != 1);

  # Since this is a recursive function, the local and global states
  # must be managed separately:
  (reduce ($n|properDivisors) as $d ([0, .]; # count, global
        ($n/$d) as $t
	| ($t|tostring) as $ts
        | if .[1].cache|has($ts) then . else .[1].cache[$ts] = (.[1]|erdosFactorCount($t).count) end
        | .[0] += (.[1].cache[$ts])
    )) as $update
  | .count = $update[0] + 1
  | .cache = ($update[1].cache) ;

def task1:
  def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;
  def neatly:  _nwise(4) | map(tostring|lpad(20)) | join(" ");

  moreMultiples([1]; [48|proper_divisors])
  | sort
  | map(. + [48]) + [[1, 48]]
  | "\(length) sequences using first definition:", neatly,

    (. as $listing
     | reduce range(0; $listing|length) as $i ([];
          $listing[$i] as $seq
          | (if ($seq[-1] != 48) then $seq + [48] else $seq end) as $seq
          | . + [[ range(1; $seq|length) as $i | ($seq[$i]/$seq[$i-1]) | floor ]] )
     | "\n\(length) sequences using second definition:", neatly );

# Stream the values of A163272:
def A163272:
  0,1,
  ({n:4}
  | while(true;
      .emit=null
      | erdosFactorCount(.n) # update the cache
      | if .count == .n then .emit =.n else . end
      | .n += 4 )
  | select(.emit).emit);

task1,
"",
"OEIS A163272:", limit(7; A163272)
