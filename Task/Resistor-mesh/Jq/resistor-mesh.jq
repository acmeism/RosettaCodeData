# Create a $rows * $columns matrix initialized with the input value
def matrix($rows; $columns):
  . as $in
  | [range(0;$columns)|$in] as $row
  | [range(0;$rows)|$row];

def Node($v; $fixed):
  {$v, $fixed};

# input: a suitable matrix of Nodes
def setBoundary:
  .[1][1].v = 1
  | .[1][1].fixed = 1
  | .[6][7].v = -1
  | .[6][7].fixed = -1 ;

# input: {d, m} where
#   .d and .m are matrices (as produced by matrix(h; w)) of Nodes
# output: {d, m, diff} with d updated
def calcDiff($w; $h):
  def adjust($cond; action): if $cond then action | .n += 1 else . end;

  reduce range(0; $h) as $i (.diff = 0;
    reduce range(0; $w) as $j (.;
      .v = 0
      | .n = 0
      | adjust($i > 0;      .v += .m[$i-1][$j].v)
      | adjust($j > 0;      .v += .m[$i][$j-1].v)
      | adjust($i + 1 < $h; .v += .m[$i+1][$j].v)
      | adjust($j + 1 < $w; .v += .m[$i][$j+1].v)
      | .v = .m[$i][$j].v - .v/.n
      | .d[$i][$j].v = .v
      | if (.m[$i][$j].fixed == 0) then .diff += .v * .v else . end ) ) ;

# input: a mesh of width w and height h, i.e. a matrix as prodcued by matrix(h;w)
def iter:
  length as $h
  | (.[0]|length) as $w
  | { m : .,
      d : (Node(0;0) | matrix($h; $w)),
      cur: [0,0,0],
      diff: 1e10 }
  | until (.diff <= 1e-24;
      .m |= setBoundary
      | calcDiff($w; $h)
      | reduce range(0;$h) as $i (.;
          reduce range(0;$w) as $j (.;
            .m[$i][$j].v += (- .d[$i][$j].v) )) )
  | reduce range(0; $h) as $i (.;
      reduce range(0; $w) as $j (.;
          .k = 0
          | if ($i != 0)     then .k += 1 else . end
          | if ($j != 0)     then .k += 1 else . end
          | if ($i < $h - 1) then .k += 1 else . end
          | if ($j < $w - 1) then .k += 1 else . end
          | .cur[.m[$i][$j].fixed + 1] += .d[$i][$j].v * .k ))
  | (.cur[2] - .cur[0]) / 2 ;

def task($S):
  def mesh: Node(0; 0) | matrix($S; $S);
  (2 / (mesh | iter)) as $r
  | "R = \($r) ohms";

task(10)
