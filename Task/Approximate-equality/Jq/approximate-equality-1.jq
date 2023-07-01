# Return whether the two numbers `a` and `b` are close.
# Closeness is determined by the `epsilon` parameter -
# the numbers are considered close if the difference between them
# is no more than epsilon * max(abs(a), abs(b)).
def isclose(a; b; epsilon):
   ((a - b) | fabs) <= (([(a|fabs), (b|fabs)] | max) * epsilon);

def lpad($len; $fill): tostring | ($len - length) as $l | ($fill * $l)[:$l] + .;

def lpad: lpad(20; " ");

# test values
def tv: [
  {x:  100000000000000.01,             y: 100000000000000.011 },
  {x:  100.01,                         y: 100.011 },
  {x:  (10000000000000.001 / 10000.0), y: 1000000000.0000001000 },
  {x:  0.001,                          y: 0.0010000001 },
  {x:  0.000000000000000000000101,     y: 0.0 },
  {x:  ((2|sqrt) * (2|sqrt)),          y: 2.0 },
  {x:  (-(2|sqrt) * (2|sqrt)),         y: -2.0 },
  {x:  3.14159265358979323846,         y: 3.14159265358979324 }
 ]
;

tv[] | "\(.x|lpad) \(if isclose(.x; .y; 1.0e-9) then " ≈ " else " ≉ " end) \(.y|lpad)"
