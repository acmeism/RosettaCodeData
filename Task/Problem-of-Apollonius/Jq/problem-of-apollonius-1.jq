def circle:
  {"x": .[0], "y": .[1], "r": .[2]};

# Find the interior or exterior Apollonius circle of three circles:
# ap(circle, circle, circle, boolean)
# Specify s as true for interior; false for exterior
def ap(c1; c2; c3; s):
  def sign: if s then -. else . end;
    (c1.x * c1.x) as $x1sq
  | (c1.y * c1.y) as $y1sq
  | (c1.r * c1.r) as $r1sq
  | (c2.x * c2.x) as $x2sq
  | (c2.y * c2.y) as $y2sq
  | (c2.r * c2.r) as $r2sq
  | (c3.x * c3.x) as $x3sq
  | (c3.y * c3.y) as $y3sq
  | (c3.r * c3.r) as $r3sq

  | (2 * (c2.x - c1.x)) as $v11
  | (2 * (c2.y - c1.y)) as $v12
  | ($x1sq - $x2sq + $y1sq - $y2sq - $r1sq + $r2sq) as $v13

  | (2 * (c2.r - c1.r) | sign) as $v14
  | (2 * (c3.x - c2.x)) as $v21
  | (2 * (c3.y - c2.y)) as $v22

  | ($x2sq - $x3sq + $y2sq - $y3sq - $r2sq + $r3sq) as $v23
  | ( 2 * c3.r - c2.r | sign) as $v24
  | ($v12 / $v11) as $w12
  | ($v13 / $v11) as $w13
  | ($v14 / $v11) as $w14

  | (($v22 / $v21) - $w12) as $w22
  | (($v23 / $v21) - $w13) as $w23
  | (($v24 / $v21) - $w14) as $w24

  | (-$w23 / $w22) as $p
  | ( $w24 / $w22) as $q
  | ((-$w12*$p) - $w13) as $m
  | ( $w14 - ($w12*$q)) as $n

  | ( $n*$n + $q*$q - 1 ) as $a
  | (2 * (($m*$n - $n*c1.x + $p*$q - $q*c1.y) + (c1.r|sign))) as $b
  | ($x1sq + $m*$m - 2*$m*c1.x + $p*$p + $y1sq - 2*$p*c1.y - $r1sq) as $c

  | ( $b*$b - 4*$a*$c ) as $d                   # discriminant
  | (( -$b - (($d|sqrt))) / (2 * $a)) as $rs    # root

  | [$m + ($n*$rs),  $p + ($q*$rs),  $rs]
  | circle
;
