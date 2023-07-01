def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def motzkin:
  . as $n
  | reduce range(2; $n+1) as $i (
      {m: [1,1]};
      .m[$i] = (.m[$i-1] * (2*$i + 1) + .m[$i-2] * (3*$i -3))/($i + 2))
  | .m ;


" n          M[n]        Prime?",
"------------------------------",

(41 | motzkin
 | range(0;length) as $i
 |"\($i|lpad(2)) \(.[$i]|lpad(20)) \(.[$i]|if is_prime then "prime" else "" end)")
