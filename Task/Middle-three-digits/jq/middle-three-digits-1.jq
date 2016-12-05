def middle3:
  if . <  0 then -. else . end
  | tostring as $s
  | ($s | length) as $n
  | if $n<3 or ($n % 2) == 0 then "invalid length: \($n)"
    else (($n - 1) / 2) as $n |  $s[$n - 1 : $n + 2]
    end ;

(123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0)
  | "\(.) => \( .|middle3 )"
