# Output is in the same units as radius; angles are in degrees.
def arclength(radius; angle1; angle2):
  def pi: 1 | atan * 4;
  (360 - ((angle2 - angle1)|length)) * (pi/180) * radius;

# The task:
arclength(10; 10; 120)
