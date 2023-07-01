# Generic functions
def array($n): . as $in | [range(0;$n)|$in];

def when(filter; action): if filter // null then action else . end;

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# module  Sandpile

# 'a' is a list of integers in row order
def new($a):
  ($a|length) as $length
  | ($length|sqrt|floor) as $rows
  | if ($rows * $rows != $length) then "The matrix of values must be square." | error
    else
    {$a,
     $rows,
     neighbors:
        (reduce range(0; $length) as $i (null;
         .[$i] = []
         | when($i % $rows > 0;       .[$i] += [$i-1] )
         | when(($i + 1) % $rows > 0; .[$i] += [$i+1] )
         | when($i - $rows >= 0;      .[$i] += [$i-$rows] )
         | when($i + $rows < $length; .[$i] += [$i+$rows] ) ) )
    }
    end;

def isStable:
  all(.a[]; . <= 3);

def tos:
  . as $in
  | .rows as $rows
  | reduce range(0; $rows) as $i ("";
      reduce range(0; $rows) as $j (.;
        . + " \($in.a[$rows*$i + $j] | lpad(2))" )
      | . +"\n" );

# just topple once so we can observe intermediate results
def topple:
  last(
    label $out
    | foreach range(0; .a|length) as $i (.;
        if .a[$i] > 3
        then .a[$i] += -4
        | reduce .neighbors[$i][] as $j (.; .a[$j] += 1)
        | ., break $out
       else .
       end ) );

def avalanche:
  until(isStable; topple);

# str1 and str2 should be strings representing a sandpile (i.e. .a)
def printAcross(str1; str2):
  (str1|split("\n")) as $r1
  | (str2|split("\n")) as $r2
  | ($r1|length - 1) as $rows
  | ($rows/2|floor) as $cr
  | reduce range(0; $rows) as $i ("";
        (if $i == $cr then "->" else "  " end) as $symbol
        | . + "\($r1[$i]) \($symbol) \($r2[$i])\n" ) ;

{ a1: (0|array(25))}
| .a2 = .a1
| .a3 = .a1
| .a1[12] = 4
| .a2[12] = 6
| .a3[12] = 16
| .a4 = (0|array(100))
| .a4[55] = 64

| (.a1, .a2, .a3, .a4) as $a
| .s = new($a)
| (.s|tos) as $str1
| .s |= avalanche
| (.s|tos) as $str2
| printAcross($str1; $str2)
