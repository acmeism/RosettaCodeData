# Input should be an array of 0s and 1s
def setRightBits($e; $n):
  if $e == 0 or $n <= 0 then .
  else . as $bits
  | reduce range(0; $e - 1) as $i ({bits2: .};
         $bits[$i] as $c
         | if $c == 1
           then .j = $i + 1
           | until (.j > ($i + $n) or .j >= $e;
                .bits2[.j] = 1
                | .j += 1 )
           end)
  |  .bits2
  end;

def b:
  "010000000000100000000010000000010000000100000010000010000100010010";

def tests:
  [["1000", 2], ["0100", 2], ["0010", 2], ["0000", 2], [b, 0], [b, 1], [b, 2], [b, 3]];

tests[] as [$bits, $n]
| ($bits|length) as $e
| "n = \($n); Width e = \($e):",
  "    Input b: \($bits)",
  ( ($bits | [explode[] | . - 48]) as $b
    | "     Result: \($b | setRightBits($e; $n) | join(""))\n" )
