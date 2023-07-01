def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;
def rpad($len): tostring | ($len - length) as $l | . + (" " * $l)[:$l];

def jacobi(a; n):
  {a: (a % n), n: n, result: 1}
  | until(.a == 0;
          until( .a % 2 != 0;
                 .a /= 2
                 | if (.n % 8) | IN(3, 5) then .result *= -1 else . end )
          | {a: .n, n: .a, result}   # swap .a and .n
	  | (.n % 4) as $nmod4
          | if (.a % 4) == $nmod4 and $nmod4 == 3 then .result *= -1 else . end
          | .a = .a % .n )
  | if .n == 1 then .result else 0 end ;

"                Table of jacobi(a; n)",
"n\\k   1   2   3   4   5   6   7   8   9  10  11  12",
"_____________________________________________________",
(range( 1; 32; 2) as $n
 | "\($n|rpad(3))" + reduce range(1; 13) as $a (""; . + (jacobi($a; $n) | lpad(4) ))
 )
