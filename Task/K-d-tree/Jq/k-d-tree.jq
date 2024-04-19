### Generic utilities
# Output: a PRN in range(0; .)
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def rand: 1000 | prn / 1000;

def randomPt($dim):
  [ range(0; $dim) | rand ] ;

def randomPts($dim; $n):
  [ range(0;$n) | randomPt($dim) ];

def sq: .*.;

# $p and $q should be numeric arrays of the same length
def PtSqd($p; $q):
  [$p, $q] | transpose | map((.[0] - .[1]) | sq) | add;


### K-d trees

def HyperRect($min; $max):
  { $min, $max };

def NearestNeighbor($nearest; $distSqd; $nodesVisited):
  { $nearest, $distSqd, $nodesVisited };

def KdNode($domElt; $split; $left; $right):
  {$domElt, $split, $left, $right};

def KdTree($pts; $bounds):
  def nk2($exset; $split):
    if ($exset|length == 0) then null
    else { $exset }
    | .exset |= sort_by(.[$split])
    | .m = ((.exset|length/2)|floor)
    | .exset[.m] as $d
    | until (.m + 1 >= (.exset|length) or .exset[.m + 1][$split] != $d[$split];
        .m += 1)
    | .s2 = $split + 1
    | if .s2 == ($d|length) then .s2 = 0 else . end
    | KdNode($d;
             $split;
             nk2(.exset[: .m]; .s2);
             nk2(.exset[.m + 1 :]; .s2)
            )
    end ;

  { n: nk2($pts; 0),
    $bounds } ;

# Input: a KdTree
def nearest($p):
  # Input: a KdTree
  def nn_($target; $hr; $maxDistSqd):
    if not then NearestNeighbor(null; infinite; 0)
    else .split as $s
    | .domElt as $pivot
    | .left as $left
    | .right as $right
    | ($target[$s] <= $pivot[$s]) as $targetInLeft
    | { nodesVisited: 1,
        leftHr: $hr,
        rightHr: $hr }
    | .leftHr.max[$s] = $pivot[$s]
    | .rightHr.min[$s] = $pivot[$s]
    | (if $targetInLeft then $left else $right end) as $nearerKd
    | (if $targetInLeft then .leftHr else .rightHr end) as $nearerHr
    | (if $targetInLeft then $right else $left end) as $furtherKd
    | (if $targetInLeft then .rightHr else .leftHr end) as $furtherHr
    | ($nearerKd | nn_($target; $nearerHr; $maxDistSqd)) as $res
    | .nearest = $res.nearest
    | .distSqd = $res.distSqd
    | .nodesVisited += $res.nodesVisited
    | .maxDistSqd2 = ([.distSqd, $maxDistSqd] | min)
    | .d = (($pivot[$s] - $target[$s]) | sq)
    | if .d > .maxDistSqd2 then NearestNeighbor(.nearest; .distSqd; .nodesVisited)
      else .d = PtSqd($pivot; $target)
      |  if .d < .distSqd
         then .nearest = $pivot
         | .distSqd = .d
         | .maxDistSqd2 = .distSqd
         else .
         end
      | ($furtherKd | nn_($target; $furtherHr; .maxDistSqd2)) as $temp
      | .nodesVisited += $temp.nodesVisited
      | if $temp.distSqd < .distSqd
        then .nearest = $temp.nearest
        | .distSqd = $temp.distSqd
        else .
        end
      | NearestNeighbor(.nearest; .distSqd; .nodesVisited)
      end
    end ;

  .n | nn_($p; .bounds; infinite);

def example($heading; $hr; $points; $p):
  KdTree($points; .hr)
  | nearest($p)
  |  "\(heading):",
    "Point            : \($p)",
    "Nearest neighbor : \(.nearest)",
    "Distance         : \(.distSqd | sqrt)",
    "Nodes visited    : \(.nodesVisited)",
    "";

### Examples

def points: [[2, 3], [5, 4], [9, 6], [4, 7], [8, 1], [7, 2]];

example("WP example data";
  HyperRect([0, 0]; [10, 10]); points; [9,2] ),

example("1,000 random 3D points";
  HyperRect([0, 0, 0]; [1, 1, 1]); randomPts(3; 1000); randomPt(3)),

example("400,000 random 3D points";
  HyperRect([0, 0, 0]; [1, 1, 1]); randomPts(3; 400,000); randomPt(3))
