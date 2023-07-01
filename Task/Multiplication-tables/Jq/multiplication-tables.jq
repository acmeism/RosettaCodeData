def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def multiplication($n):
  ($n*$n|tostring|length) as $len
  | ["x", range(0; $n + 1)] | map(lpad($len)) | join(" "),
    (["", range(0; $n + 1)] | map($len*"-")   | join(" ")),
    ( range(0; $n + 1) as $i
      | [$i,
         range(0; $n + 1) as $j
         | if $j>=$i then $i*$j else "" end]
      | map(lpad($len))
      | join(" ") ) ;

multiplication(12)
