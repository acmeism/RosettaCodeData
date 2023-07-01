def dt: 0.1;

# Input: [t, y]; yp is a filter that accepts [t,y] as input
def runge_kutta(yp):
  .[0] as $t | .[1] as $y
  | (dt * yp) as $a
  | (dt * ([ ($t + (dt/2)), $y + ($a/2) ] | yp)) as $b
  | (dt * ([ ($t + (dt/2)), $y + ($b/2) ] | yp)) as $c
  | (dt * ([ ($t + dt)    , $y + $c     ] | yp)) as $d
  | ($a + (2*($b + $c)) + $d) / 6
;

# Input: [t,y]
def dy(f): runge_kutta(f);
