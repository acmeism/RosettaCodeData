def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def sum(s): reduce s as $_ (0; . + $_);

def is_prime:
  . as $n
  | if ($n < 2)         then false
    elif ($n % 2 == 0)  then $n == 2
    elif ($n % 3 == 0)  then $n == 3
    elif ($n % 5 == 0)  then $n == 5
    elif ($n % 7 == 0)  then $n == 7
    elif ($n % 11 == 0) then $n == 11
    elif ($n % 13 == 0) then $n == 13
    elif ($n % 17 == 0) then $n == 17
    elif ($n % 19 == 0) then $n == 19
    else 23
         | until( (. * .) > $n or ($n % . == 0); .+2)
	 | . * . > $n
    end;

def digitSum($base):
  def stream:
    recurse(if . > 0 then ./$base|floor else empty end) | . % $base ;
  sum(stream);

def digit_sums_are_prime($n):
  [range(2;$n)
   | digitSum(2) as $bds
   | select($bds|is_prime)
     | digitSum(3) as $tds
     | select($tds|is_prime) ];

def task($n):
  "Numbers < \($n) whose binary and ternary digit sums are prime:",
   (digit_sums_are_prime($n)
    | length as $length
    | (_nwise(14) | map(lpad(4)) | join(" ")),
      "\nFound \($length) such numbers." );

task(200)
