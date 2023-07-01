# add as many as you please
def addVector:
  transpose | add;

# . - y
def minusVector(y):
  [.[0] - y[0], .[1] - y[1], .[2] - y[2]];

# scalar multiplication: . * s
def multVector(s):
    map(. * s);

def dot(y):
  .[0] * y[0] + .[1] * y[1] + .[2] * y[2];

def intersectPoint($rayVector; $rayPoint; $planeNormal; $planePoint):
  ($rayPoint | minusVector($planePoint)) as $diff
  | ($diff|dot($planeNormal)) as $prod1
  | ($rayVector|dot($planeNormal)) as $prod2
  | $rayPoint | minusVector($rayVector | multVector(($prod1 / $prod2) )) ;


def rv : [0, -1, -1];
def rp : [0,  0, 10];
def pn : [0,  0,  1];
def pp : [0,  0,  5];

"The ray intersects the plane at:",
intersectPoint(rv; rp; pn; pp)
