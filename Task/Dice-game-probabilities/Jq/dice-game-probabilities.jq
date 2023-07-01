# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# Input: an array (aka: counts)
def throwDie($nSides; $nDice; $s):
  if $nDice == 0
  then .[$s] +=  1
  else reduce range(1; $nSides + 1) as $i (.;
    throwDie($nSides; $nDice-1; $s + $i) )
  end ;

def beatingProbability(nSides1; nDice1; nSides2; nDice2):
  def a: [range(0; .) | 0];

  ((nSides1 + 1) * nDice1) as $len1
  | ($len1 | a | throwDie(nSides1; nDice1; 0)) as $c1

  | ((nSides2 + 1) * nDice2) as $len2
  | ($len2 | a | throwDie(nSides2; nDice2; 0)) as $c2

  |((nSides1|power(nDice1)) * (nSides2|power(nDice2))) as $p12

  | reduce range(0; $len1) as $i (0;
      reduce range(0; [$i, $len2] | min) as $j (.;
          . + ($c1[$i] * $c2[$j] / $p12) ) ) ;

beatingProbability(4; 9; 6; 6),
beatingProbability(10; 5; 7; 6)
