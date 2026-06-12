import math, strformat

const
  Re = 6371000  # Radius of earth in meters.
  Dd= 0.001     # Integrate in this fraction of the distance already covered.
  Fin = 1e7     # Integrate only to a height of 10000km, effectively infinity.


func rho(a: float): float =
  ## The density of air as a function of height above sea level.
  exp(-a / 8500)


func height(a, z, d: float): float =
  ## Height as a function of altitude (a), zenith angle (z)
  ## in degrees and distance along line of sight (d).
  let aa = Re + a
  let hh = sqrt(aa * aa + d * d - 2 * d * aa * cos(degToRad(180-z)))
  result = hh - Re


func columnDensity(a, z: float): float =
  ## Integrates density along the line of sight.
  var d = 0.0
  while d < Fin:
    let delta = max(Dd, Dd * d)   # Adaptive step size to avoid it taking forever.
    result += rho(height(a, z, d + 0.5 * delta)) * delta
    d += delta


func airmass(a, z: float): float =
  columnDensity(a, z) / columnDensity(a, 0)


echo "Angle     0 m              13700 m"
echo "------------------------------------"
var z = 0.0
while z <= 90:
  echo &"{z:2}      {airmass(0, z):11.8f}      {airmass(13700, z):11.8f}"
  z += 5
