def sum(stream): reduce stream as $x (0; . + $x);

def genSequence($ones; $numZeros):
  if $ones|length == 0 then "." * $numZeros
  else range(1; $numZeros - ($ones|length) + 2) as $x
  | genSequence($ones[1:]; $numZeros - $x) as $tail
  |  "." * $x + $ones[0] + $tail
  end;

def printBlock($data; $len):
  sum($data | explode[] |  . - 48) as $sumChars
  | "\nblocks \($data), cells \($len)",
    (if $len - $sumChars <= 0
     then "No solution"
     else ( $data | explode | map( "1" * (. - 48) ) ) as $prep
     | genSequence($prep; $len - $sumChars + 1)[1:]
     end) ;

printBlock(  "21";  5),
printBlock(    "";  5),
printBlock(   "8"; 10),
printBlock("2323"; 15),
printBlock(  "23";  5)
