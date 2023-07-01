def count(s): reduce s as $x (0; .+1);

# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# Output: a possibly empty array of pairs
def factor_pairs:
  . as $n
  | ($n / (10 | power($n|tostring|length / 2) - 1)) as $first
  | [range($first|floor; 1 + ($n | sqrt)) | select(($n % .) == 0) | [., $n / .] ] ;

# Output: a stream
def vampire_factors:
  def es: tostring|explode;
  . as $n
  | tostring as $s
  | ($s|length) as $nlen
  | if ($nlen % 2) == 1 then []
    else ($nlen / 2 ) as $half
    | [factor_pairs[]
       | select(. as [$a, $b]
           | ($a|tostring|length) == $half and ($b|tostring|length) == $half
             and count($a, $b | select(.%10 == 0)) != 2
             and ((($a|es) + ($b|es)) | sort) == ($n|es|sort) ) ]
    end ;

def task1($n):
  limit($n; range(1; infinite)
    | . as $i
    | vampire_factors
    | select(length>0)
    | "\($i):\t\(.)" );

def task2:
  16758243290880, 24959017348650, 14593825548650
  | vampire_factors as $vf
  | if $vf|length == 0
    then "\(.) is not a vampire number!"
    else "\(.):\t\($vf)"
    end;

task1(25),
"",
task2
