def pi: 4 * (1|atan);

def deg2rad: . * pi / 180;

def rad2deg: if . == null then null else . * 180 / pi end;

# Input: [x,y] (special handling of x==0)
# Output: [r, theta] where theta may be null
def to_polar:
  if .[0] == 0
  then [1, if .[1] > 5e-14 then pi/2 elif .[1] < -5e-14 then -pi/2 else null end]
  else [1, ((.[1]/.[0]) | atan)]
  end;

def from_polar: .[1] | [ cos, sin];

def abs: if . < 0 then - . else . end;

def summation(f): map(f) | add;
