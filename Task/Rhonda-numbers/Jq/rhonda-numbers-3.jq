# Emit a stream of Rhonda numbers in the given base
def rhondas($b):
  range(1; infinite) as $n
  | ($n | [digits($b)]) as $digits
  | select($digits|index(0)|not)
  | select(($b != 10) or (($digits|index(5)) and ($digits | any(. % 2 == 0))))
  | select(prod($digits[]) == ($b * sigma($n | factors)))
  | $n ;
