# MATRIX MATH
  def mult(m; v):
    [ m[0][0] * v[0] + m[0][1] * v[1],
      m[1][0] * v[0] + m[1][1] * v[1] ];

  def minus(a; b): [ a[0]-b[0], a[1]-b[1] ];

  def plus(a; b):  [ a[0]+b[0], a[1]+b[1] ];

# SVG STUFF
  # default values of stroke and stroke-width are provided
  def style(obj):
    { "stroke": "rgb(255, 15, 131)", "stroke-width": "2px" } as $default
    | ($default + obj) as $s
    | "<style type='text/css' media='all'>
       .dragon { stroke:\($s.stroke); stroke-width:\($s["stroke-width"]); }
       </style>";

  def svg(id; width; height):
    "<svg width='\(width // "100%")' height='\(height // "100%") '
          id='\(id)'
          xmlns='http://www.w3.org/2000/svg'>";

  # Turn a pair of points into an SVG path like "M1 1L2 2" (M=move to; L=line to).
  def toSVGpath(a; b):
     "M\(a[0]) \(a[1])L\(b[0]) \(b[1])";

# DRAGON MAKING

  def fractalMakeDragon(svgid; ptA; ptC; steps; left; css):

    # Make a new point, either to the left or right
    def growNewPoint(ptA; ptC; left):
        [[ 1/2,-1/2 ], [ 1/2, 1/2 ]]  as $left
      | [[ 1/2, 1/2 ], [-1/2, 1/2 ]]  as $right
      | plus(ptA;
             mult(if left then $left else $right end;
                  minus(ptC; ptA)));

    def grow(ptA; ptC; steps; left):
      # if we have more iterations to go...
      if steps > 1 then
        growNewPoint(ptA; ptC; left) as $ptB
        # ... then recurse using each new line, one left, one right
        | grow($ptB; ptA; steps-1; left),
          grow($ptB; ptC; steps-1; left)
      else
        toSVGpath(ptA; ptC)
      end;

    svg(svgid; "100%"; "100%"),
      style(css),
      "<path class='dragon' d='",
         grow(ptA; ptC; steps; left),
      "'/>",
    "</svg>";
