def add(stream): reduce stream as $x (0; . + $x);

# input should be an integer
def commatize:
  def digits: tostring | explode | reverse;
  if . == null then ""
  elif . < 0 then "-" + ((- .) | commatize)
  else [foreach digits[] as $d (-1; .+1;
          # "," is 44
          (select(. > 0 and . % 3 == 0)|44), $d)]
  | reverse
  | implode
  end;

def count(stream): reduce stream as $i (0; . + 1);

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# unordered
def proper_divisors:
  . as $n
  | if $n > 1 then 1,
      ( range(2; 1 + (sqrt|floor)) as $i
        | if ($n % $i) == 0 then $i,
            (($n / $i) | if . == $i then empty else . end)
         else empty
	 end)
    else empty
    end;

def chowla:
  if . == 1 then 0
  else add(proper_divisors) - 1
  end;

# Input: a positive integer
def is_chowla_prime:
  . > 1 and chowla == 0;

# In the interests of green(er) computing ...
def chowla_primes($n):
  2, range(3; $n; 2) | select(is_chowla_prime);

def report_chowla_primes:
  reduce range(2; 10000000) as $i (null;
    if $i | is_chowla_prime
    then if $i < 10000000 then .[7] += 1 else . end
    |    if $i <  1000000 then .[6] += 1 else . end
    |    if $i <   100000 then .[5] += 1 else . end
    |    if $i <    10000 then .[4] += 1 else . end
    |    if $i <     1000 then .[3] += 1 else . end
    |    if $i <      100 then .[2] += 1 else . end
    else . end)
  | (range(2;8) as $i
  |  "10 ^ \($i) \(.[$i]|commatize|lpad(16))") ;

def is_chowla_perfect:
  (. > 1) and (chowla == . - 1);

def task:
  "  n\("chowla"|lpad(16))",
  (range(1;38) | "\(lpad(3)): \(chowla|lpad(10))"),
  "\n  n          \("Primes < n"|lpad(10))",
  report_chowla_primes,
#  "\nPerfect numbers up to 35e6",
#  (range(1; 35e6) | select(is_chowla_perfect) | commatize)
""
;

task
