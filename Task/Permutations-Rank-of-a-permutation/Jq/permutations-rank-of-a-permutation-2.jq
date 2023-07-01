# Myrvold and Ruskey algorithm
# The input should be a permutation of 0 ... $n-1 inclusive
def mrUnrank1($rank; $n):
  if $n < 1 then .
  else ($rank|divmod($n)) as [$q, $r]
  | swap($r; $n - 1)
  | mrUnrank1($q; $n - 1)
  end ;

# The input should be a permutation of 0 ... $n-1 inclusive
def mrRank1($n; $vec):
  if $n < 2 then 0
  else
  . as $inv
  | $vec
  | .[$n-1] as $s
  | swap($n - 1; $inv[$n-1]) as $vec
  | $inv
  | swap($s; $n - 1)
  | $s + $n * mrRank1($n - 1; $vec)
  end;


def getPermutation($rank; $n):
 [range(0; $n)]
 | mrUnrank1($rank; $n) ;

def getRank($n; $vec):
  reduce range(0; $n) as $i ( null;
    .[$vec[$i]] = $i )
  | mrRank1($n; $vec);

def task($k):
  "\($k)!",
  (range(0; $k|factorial) as $r
   | getPermutation($r; $k)
   | [ ($r|lpad(2)), tostring, (getRank($k; .) | lpad(2)) ]
   | join(" -> ") );

def task3:
  def randoms: 43154690, 150112966, 15732396, 157551691;
  "\("#"|lpad(10)) -> \("permutation"|lpad(27)) -> \("rank"|lpad(10))",
  (randoms as $r
   | getPermutation($r; 12)
   | "\($r|lpad(10)) -> \(lpad(27)) -> \(getRank(12;.)|lpad(10))" );


task(3),
"",
task(4),
"",
task3
