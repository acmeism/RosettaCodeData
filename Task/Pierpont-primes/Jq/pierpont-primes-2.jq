# Input: the target number of primes of the form p(u,v) == 2^u * 3^v ± 1.
# The main idea is to let u run from 0:m and v run from 0:n where n ~~ 0.63 * m.
# Initially we start with plausible values for m and n ($maxm and $maxn respectively),
# and then check whether these have been chosen conservatively enough.
#
def pierponts($firstkind):
  . as $N
  | (if $firstkind then 1 else -1 end) as $incdec

  # Input:  [$maxm, $maxn]
  # Output: an array of objects of the form {p, m, n}
  # where .p is prime and .m and .n are the corresponding powers of 2 and 3
  | def pp:
      . as [$maxm, $maxn]
      | [ ({p2:1, m:0},
           (foreach range(0; $maxm) as $m (1; . * 2; {p2: ., m: ($m + 1)}))) as $a
        | ({p3:1, n:0},
	   (foreach range(0; $maxn) as $n (1; . * 3; {p3: ., n: ($n + 1)}))) as $b
        | {p: ($a.p2 * $b.p3 + $incdec), m: $a.m, n: $b.n}
        | select(.p|is_prime) ]
      | unique_by(.p)
      # | (length|debug) as $debug # informative
      | .;

  # input: output of pp
  # check that length is sufficient, and that $maxm and $maxn are large enough
  def adequate($maxm; $maxn):
    # ( ".[$N-1].m is \(.[$N-1].m) vs $maxm=\($maxm)" | debug) as $debug |
    # ( ".[$N-1].n is \(.[$N-1].n) vs $maxn=\($maxn)" | debug) as $debug |
    length > $N
    and .[$N-1].m < $maxm - 3   # -2 is not sufficient
    and .[$N-1].n < $maxn - 3   # -2 is not sufficient
    ;

  # If our search has not been `adequate` then increase $maxm and $maxn
  # input: [maxm, maxn, ([maxm,maxn]|pp)]
  # output: pp
  def adapt:
    . as [$maxm, $maxn, $one]
    | if ($one|adequate($maxm; $maxn)) then $one
      else [$maxm + 2, $maxn + 1.6] as $maxplus
      # | ("retrying with \($maxplus)" | debug) as $debug
      |  ($maxplus|pp) as $two
      |  $maxplus + [$two] | adapt
      end;

  # We start by selecting m and n so that
  # m*n >> $N, i.e., 0.63 * m^2 >> $N , so m >> sqrt(1.585 * $N)
  # Using 7 as the constant to start with is sufficient to avoid too much rework.
  ((9 * $N) | sqrt) as $maxm
  | (0.63 * $maxm + 1) as $maxn
  | [$maxm, $maxn] as $max
  | ($max | pp) as $pp
  | ($max + [$pp]) | [adapt[:$N][].p] ;

# The stretch goal:
def stretch:
  250
  | "\nThe \(.)th Pierpoint prime of the first kind is \(pierponts(true)[-1])",
    "\nThe \(.)th Pierpoint prime of the second kind is \(pierponts(false)[-1])" ;

# The primary task:
50
| "\nThe first \(.) Pierpoint primes of the first kind:", (pierponts(true) | table(10;8)),
  "\nThe first \(.) Pierpoint primes of the second kind:", (pierponts(false) | table(10;8))
