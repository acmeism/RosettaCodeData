# Emit {x,y,r} corresponding to the circle through the three points
# specified as [x,y] pairs.
def findcircle($p1; $p2; $p3):

  def assertEq($p; $q): if ($p - $q)|length < 1e-12 then . else "assertion failed: \($p) != \($q)" | error end;

  def ss($a; $b) : ($a|.*.) + ($b|.*.);

    $p1 as [$a,$b]
  | $p2 as [$c,$d]
  | $p3 as [$e,$f]

  | ($a - $e) as $ae
  | ($d - $b) as $db
  | ($b - $f) as $bf
  | ($e - $c) as $ec
  | ($c - $a) as $ca
  | ($f - $d) as $fd

  | ss($a; $b) as $a2b2
  | ss($c; $d) as $c2d2
  | ss($e; $f) as $e2f2

  | {x: (0.5 * ($a2b2 * $fd + $c2d2 * $bf + $e2f2 * $db) / ($a * $fd + $c * $bf + $e * $db)),
     y: (0.5 * ($a2b2 * $ec + $c2d2 * $ae + $e2f2 * $ca) / ($b * $ec + $d * $ae + $f * $ca)) }
  # any one of these should do / be nearly identical:
  | [ss(.x-$a; .y-$b), ss(.x-$c; .y-$d), ss(.x-$e; .y-$f)] as $r123
  | assertEq( $r123|max; $r123|min )
  | .r = (($r123 | add) / 3 | sqrt) ;

findcircle( [22.83, 2.07]; [14.39, 30.24]; [33.65, 17.31])
| "Centre = \([.x, .y]), radius = \(.r)"
