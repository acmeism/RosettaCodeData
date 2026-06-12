# For gojq
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# For pretty-printing
def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

"  n    number            number^2",
(range(0;8) as $n
 | ((("1"*$n) + "3") | tonumber) as $number
 | ($n|lpad(3)) + ($number|lpad(10)) + ($number|power(2)|lpad(20)) )
