def almkvistGiullera(print):
  . as $n
  | ((6*$n) | factorial * 32) as $t1
  | (532*$n*$n + 126*$n + 9) as $t2
  | (($n | factorial | power(6))*3) as $t3
  | ($t1 * $t2 / $t3) as $ip
  | ( 6*$n + 3) as $pw
  | r($ip; 10 | power($pw)) as $tm
  | if print
    then "\($n|lpad(2)) \($ip|lpad(44)) \(-$pw|lpad(3)), \($tm|r_to_decimal(100))"
    else $tm
    end;
