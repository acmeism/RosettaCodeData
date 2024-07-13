def Point($x;$y): {x:$x, y:$y};   # jq and gojq allow: {$x,$y}

def ppArray:
  def pp: "(\(.x), \(.y))";
  "[" + (map(pp) | join(", ")) + "]";

def rdp($eps):
  . as $l
  | {x: 0,
     dMax: -1}
  | .p1 = $l[0]  # first
  | .p2 = $l[-1] # last
  | (.p2.x - .p1.x) as $x21
  | (.p2.y - .p1.y) as $y21
  | reduce range(1; ($l|length)) as $i (.;
      .p = $l[$i]
      | ( ($y21*.p.x - $x21*.p.y + .p2.x*.p1.y - .p2.y*.p1.x) | length) as $d  # abs ~ length
      | if $d > .dMax then .x += 1 | .dMax = $d end )
  | if .dMax > $eps
    then ($l[0: 1+.x]|rdp($eps)) + ($l[.x:]|rdp(eps))[1:]
    else [$l[0], $l[-1]]
    end;

def points: [
    Point(0; 0), Point(1; 0.1), Point(2; -0.1), Point(3; 5), Point(4; 6),
    Point(5; 7), Point(6; 8.1), Point(7;    9), Point(8; 9), Point(9; 9)
];

points | rdp(1) | ppArray
