# Emit a proof that the input is a pythagorean quad, or else false
def is_pythagorean_quad:
  . as $d
  | (.*.) as $d2
  | first(
      label $continue_a | range(1; $d) | . as $a | (.*.) as $a2
    |   if 3*$a2 > $d2 then break $continue_a else . end
    | label $continue_b | range($a; $d) | . as $b | (.*.) as $b2
    |   if $a2  + 2 * $b2  > $d2 then break $continue_b else . end
    | (($d2-($a2+$b2)) | sqrt) as $c
    | if ($c | floor) == $c then [$a, $b, $c] else empty end )
  // false;

# The specific task:

[range(1; 2201) | select( is_pythagorean_quad | not )] | join(" ")
