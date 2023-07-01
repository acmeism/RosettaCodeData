def sum_of_squares(stream): reduce stream as $x (0; . + $x * $x);

def distanceSquared(P1; P2): sum_of_squares(P1[0]-P2[0], P1[1]-P2[1]);

# Emit {x1,y1, ...} for the input triangle
def xy:
  { x1: .[0][0],
    y1: .[0][1],
    x2: .[1][0],
    y2: .[1][1],
    x3: .[2][0],
    y3: .[2][1] };

def EPS: 0.001;
def EPS_SQUARE: EPS * EPS;
