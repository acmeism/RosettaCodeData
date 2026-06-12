# nCk assuming n >= k
def binomial(n; k):
  if k > n / 2 then binomial(n; n-k)
  else reduce range(1; k+1) as $i (1; . * (n - $i + 1) / $i)
  end;

def forward:
  . as $a
  | reduce range(0; $a|length) as $n (null;
      reduce range(0;$n+1) as $k (.;
        .[$n] += binomial($n; $k) * $a[$k] ) );

def inverse:
  . as $b
  | reduce range (0; $b|length) as $n (null;
      reduce range(0; $n+1) as $k (.;
        (if (($n - $k) % 2 == 0) then 1 else -1 end) as $sign
        | .[$n] += binomial($n; $k) * $b[$k] * $sign ));

def selfInverting:
  . as $a
  | reduce range(0; $a|length) as $n (null;
      reduce range(0; $n+1) as $k (.;
        (if $k % 2 == 0 then 1 else -1 end) as $sign
        | .[$n] += binomial($n; $k) * $a[$k] * $sign ));

def seqs: [
    [1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845, 35357670, 129644790, 477638700, 1767263190],
    [0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0],
    [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181],
    [1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37]
];

def names: [
    "Catalan number sequence:",
    "Prime flip-flop sequence:",
    "Fibonacci number sequence:",
    "Padovan number sequence:"
];

def task:
  range(0; seqs|length) as $i
  | names[$i],
    (seqs[$i]|join(" ")),
    "Forward binomial transform:",
    ( (seqs[$i]|forward)
      | join(" "),
      "Inverse binomial transform:",
      ((seqs[$i]|inverse)|join(" ")),
      "Round trip:",
      (inverse|join(" ")) ),
    "Self-inverting:",
    ( (seqs[$i]|selfInverting)
      | join(" "),
        "Re-inverted:",
        (selfInverting|join(" ")) ),
    (select($i < (seqs|length - 1) ) | "") ;

task
