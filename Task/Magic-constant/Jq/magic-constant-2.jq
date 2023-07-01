def magicConstant: (.*. + 1) * . / 2;

"First 20 magic constants:",
 ([range(3;23)
  | magicConstant]
  | group(10) | map(lpad(5)) | join(" ")),
 "",
 "1,000th magic constant: \( 1002| magicConstant)",
 "",
 "Smallest order magic square with a constant greater than:",
 (range(1; 21) as $i
  | (10 | power($i)) as $goal
  | ((($goal * 2)|iroot(3) + 1) | floor) as $order
  | ("10\($i|superscript)" | lpad(5)) + ": \($order|lpad(9))"  )
