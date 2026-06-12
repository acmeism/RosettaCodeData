# constants
def RE: 6371000;   # radius of earth in meters
def DD:  0.001;    # integrate in this fraction of the distance already covered
def FIN: 1e7;      # integrate only to a height of 10000km, effectively infinity

# The density of air as a function of height above sea level.
def rho: (-./8500) | exp;

# a = altitude of observer (in m)
# z = zenith angle (in degrees)
# d = distance along line of sight (in m)
def height($a; $z; $d):
   (RE + $a) as $aa
   | (($aa * $aa + $d * $d - 2 * $d * $aa * ((180-$z)|radians|cos) )|sqrt ) - RE;

# Integrates density along the line of sight.
def columnDensity($a; $z):
  { sum: 0, d: 0 }
  | until (.d >= FIN;
      ([DD, DD * .d] | max) as $delta  # adaptive step size to avoid it taking forever
      | .sum = .sum + ((height($a; $z; .d + 0.5 * $delta))|rho) * $delta
      | .d += $delta )
  | .sum ;

def airmass(a; z): columnDensity(a; z) / columnDensity(a; 0);

"Angle     0 m              13700 m",
"------------------------------------",
( range(0; 91; 5)
  |  "\(lpad(2))      \(airmass(0; .)|fmt(11;8))      \(airmass(13700; .)|fmt(11;8))" )
