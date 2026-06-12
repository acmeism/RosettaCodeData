include "rational" {search: "."};  # see comment above

def factorial:
  reduce range(2; .+1) as $i (1; . * $i);

def apery($n):
  reduce range (1; $n+1) as $k ( r(0;1);
      radd(.; r(1; $k | . * . * .)))
  | "First \($n) terms of ζ(3) truncated to 100 decimal places (accurate to 6 decimal places):",
     r_to_decimal(100);

def markov($n):
  {fact: 1,
   fact2: 1,
   sign: -1,
   sum: r(0;1)
  }
  | reduce range (1; $n + 1) as $k (.;
      .sign *= -1
      | .fact *= $k
      | (.fact * .fact * .sign) as $num
      | .mult = 2 * $k * (2*$k - 1)
      | .fact2 *= .mult
      | ($k | .*.*.) as $cube
      | (.fact2 * $cube) as $den
      | .sum |= radd(. ; r($num; $den) ) )
  | .sum |= rmult(.; r(5; 2))
  | "First \($n) terms of Markov / Apéry representation truncated to 100 decimal places:",
    (.sum | r_to_decimal(100));

def wedeniwski($n):
  def cube: .*.*.;
  {fact: 1,
   fact2: 1,
   sign: -1,
   sum: r(0;1),
   mult: 1
  }
  | reduce range (0; $n) as $k (.;
      .sign *= -1
      | if $k > 0
        then .fact *= $k
        | .mult = 2 * $k * (2*$k - 1)
        | .fact2 *= .mult
        end
      | (.fact2 * (2*$k + 1)) as $fact3
      | (.sign * ($fact3|cube) * (.fact2|cube) * (.fact|cube)) as $num
      | ($k * $k)  as $k2
      | ($k2 * $k) as $k3
      | ($k3 * $k) as $k4
      | ($k4 * $k) as $k5
      | (126392*$k5 + 412708*$k4 + 531578*$k3 + 336367*$k2 + 104000*$k + 12463) as $tmp
      | ($num * $tmp) as $num
      | ( (3*$k + 2 | factorial) * (4*$k + 3 | factorial | cube ) ) as $d
      | .sum |= radd(.; r($num; $d)) )
  | .sum |= r( .n; 24 * .d )
  | "First \($n) terms of Wedeniwski representation truncated to 100 decimal places:",
    (.sum | r_to_decimal(100));

"Actual value to 100 decimal places:",
"1.2020569031595942853997381615114499907649862923404988817922715553418382057863130901864558736093352581",
apery(1000),
markov(158),
wedeniwski(20)
