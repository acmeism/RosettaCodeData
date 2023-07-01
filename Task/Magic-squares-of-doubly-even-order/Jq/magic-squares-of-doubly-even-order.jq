def lpad($len):
  def l: tostring | ($len - length) as $l | (" " * $l)[:$l] + .;
  if type == "array" then map(l) else l end;

def magicSquareDoublyEven:
  if . < 4 or .%4 != 0 then "Base must be a positive multiple of 4" | error else . end
  | . as $n
  # pattern of count-up vs count-down zones
  | [1,0,0,1,0,1,1,0,0,1,1,0,1,0,0,1] as $bits
  | ($n * $n) as $size
  | ($n / 4 | floor) as $mult # how many multiples of 4
  | { i:0, result: null }
  | reduce range(0; $n) as $r (.;
      reduce range(0; $n) as $c (.;
         ( (($c/$mult)|floor) + (($r/$mult)|floor) * 4) as $bitPos
         | .result[$r][$c] =
	      (if ($bits[$bitPos] != 0) then .i + 1 else $size - .i end)
         | .i += 1 ) )
  | .result ;

# Input: the order
def task:
  . as $n
  | (.*.|tostring|length+1) as $width
  | (magicSquareDoublyEven[] | lpad($width) | join(" ")),
    "\nMagic constant for order \($n): \(($n*$n + 1) * $n / 2)\n\n" ;

8, 12 | task
