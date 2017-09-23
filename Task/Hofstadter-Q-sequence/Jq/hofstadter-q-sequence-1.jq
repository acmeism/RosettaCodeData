# For n>=2, Q(n) = Q(n - Q(n-1)) + Q(n - Q(n-2))
def Q:
  def Q(n):
    n as $n
    | (if . == null then [1,1,1] else . end) as $q
    | if $q[$n] != null then $q
      else
        $q | Q($n-1) as $q1
        | $q1 | Q($n-2) as $q2
        | $q2 | Q($n - $q2[$n - 1]) as $q3   # Q(n - Q(n-1))
        | $q3 | Q($n - $q3[$n - 2]) as $q4   # Q(n - Q(n-2))
        | ($q4[$n - $q4[$n-1]] + $q4[$n - $q4[$n -2]]) as $ans
        | $q4 | setpath( [$n]; $ans)
      end ;

  . as $n | null | Q($n) | .[$n];

# count the number of times Q(i) > Q(i+1) for 0 < i < n
def flips(n):
  (reduce range(3; n) as $n
    ([1,1,1]; . + [ .[$n - .[$n-1]] + .[$n - .[$n - 2 ]] ] )) as $q
  | reduce range(0; n) as $i
      (0; . + (if $q[$i] > $q[$i + 1] then 1 else 0 end)) ;

# The three tasks:
((range(0;11), 1000) | "Q(\(.)) = \( . | Q)"),

(100000 | "flips(\(.)) = \(flips(.))")
