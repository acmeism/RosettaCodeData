# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be an integer.
def idivide($j):
  . as $i
  | ($i % $j) as $mod
  | ($i - $mod) / $j ;

def bigBig: (10|power(50)) + 151;

# The remainder when $b raised to the power $e is divided by $m:
def modPow($b; $e; $m):
   if ($m == 1) then 0
   else {r: 1, b: ($b % $m), $e}
   | until (.e <= 0;
       if (.e % 2) == 1 then .r = (.r*.b) % $m else . end
       | .e |= idivide(2)
       | .b |= ((.*.) % $m) )
   | .r
   end;

def c($ns; $ps):
    $ns as $n
    | (if $ps != "" then $ps else bigBig end) as $p

    # Legendre symbol, returns 1, 0 or p - 1
    | def ls($a): modPow($a; ($p - 1) | idivide(2); $p);

    # multiplication in Fp2 where .omega2 comes from .
    def mul($aa; $bb):
      [($aa[0] * $bb[0] + $aa[1] * $bb[1] * .omega2) % $p,
       ($aa[0] * $bb[1] + $bb[0] * $aa[1]) % $p] ;

    # Step 0, validate arguments
    if (ls($n) != 1) then [0, 0, false]
    else
    # Step 1, find a, omega2
    { a: 0, stop: false }
    | until( .stop;
        .omega2 = ((.a * .a + $p - $n) % $p)
        | if ls(.omega2) == ($p - 1)
	  then .stop = true
          else .a += 1
          end )

    # Step 2, compute power
    | { r: [1, 0],
        s: [.a, 1],
        nn: (( ($p + 1) | idivide(2)) % $p),
	omega2  }
     | until (.nn <= 0;
        if (.nn % 2) == 1 then .r = mul(.r; .s) else . end
        | .s = mul(.s; .s)
        | .nn |= idivide(2)  )

    # Step 3, check x in Fp; or that x * x = n
    | if (.r[1] != 0) or ((.r[0] * .r[0]) % $p != $n) then [0, 0, false]

    # Step 4, solutions
      else  [.r[0], $p - .r[0], true]
      end
    end;

def exercise:
c(10; 13),
c(56; 101),
c(8218; 10007),
c(8219; 10007),
c(331575; 1000003),
c(665165880; 1000000007),
c(881398088036; 1000000000039),
c(34035243914635549601583369544560650254325084643201; "")
;

exercise
