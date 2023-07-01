# Input: {p, lvl, path}
def kpath($n):
  if $n == 0 then .path=[]
  else until( .p[$n|tostring];
        .q = []
        | reduce .lvl[0][] as $x (.;
             kpath($x)
             | label $out
             | foreach (.path[], null) as $y (.;
                if $y == null then .
                else (($x + $y)|tostring) as $xy
                | if .p[$xy] then .
                  else .p[$xy] = $x
                  | .q += [$x + $y]
                  end
                end;
                select($y == null) ) )
        | .lvl[0] = .q )
  | kpath(.p[$n|tostring])
  | .path += [$n]
  end ;

# Input: as for kpath
def treePow($x; $n):
  reduce kpath($n).path[] as $i (
    {r: { "0": 1, "1": $x }, pp: 0 };
    .r[$i|tostring] = .r[($i - .pp)|tostring] * .r[.pp|tostring]
    | .pp = $i )
  | .r[$n|tostring] ;

def showPow($x; $n):
  {  p: {"1": 0},
   lvl: [[1]],
   path: []}
  | "\($n): \(kpath($n).path)",
    "\($x) ^ \($n) = \(treePow($x; $n))";


(range(0;18) as $n | showPow(2; $n)),
showPow(1.1; 81),
showPow(3; 191)
