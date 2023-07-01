def legendre:
  (sqrt | floor + 1 | eratosthenes) as $primes

  # Input: {x, a}
  # Output: {phi: phi(x,a), memo} where .memo might have been updated
  | def phi:
    . as {x: $x, a: $a, memo: $memo}
    | if $a == 0 then {phi: $x, $memo}
      else "\($x),\($a)" as $ix
      | $memo[ $ix ] as $m
      | if $m then {phi: $m, $memo}
        else .a += -1
        | phi as {phi: $phi1, memo: $memo}
        | (($x / $primes[$a - 1])|floor) as $x
        | ({$x, a, $memo} | phi) as {phi: $phi2, memo: $memo}
        | ($phi1 - $phi2) as $phi
        | {$phi, $memo}
	| .memo[$ix] = $phi
        end
      end;

  def l:
    . as $n
    | if . < 2 then 0
      else ($n|sqrt|floor|l) as $a
      | ({x: $n, $a, memo: {}} | phi).phi + $a - 1
      end;

  l;


def task:
  range(0;10)
  | . as $i
  | [., (10|power($i)|legendre)]
  ;

task
