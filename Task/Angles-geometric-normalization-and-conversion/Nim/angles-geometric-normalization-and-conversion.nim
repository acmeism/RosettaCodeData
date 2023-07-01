import math
import strformat

const Values = [float -2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1000000]

func d2d(x: float): float {.inline.} = x mod 360
func g2g(x: float): float {.inline.} = x mod 400
func m2m(x: float): float {.inline.} = x mod 6400
func r2r(x: float): float {.inline.} = x mod (2 * Pi)

func d2g(x: float): float {.inline.} = d2d(x) * 10 / 9
func d2m(x: float): float {.inline.} = d2d(x) * 160 / 9
func d2r(x: float): float {.inline.} = d2d(x) * Pi / 180

func g2d(x: float): float {.inline.} = g2g(x) * 9 / 10
func g2m(x: float): float {.inline.} = g2g(x) * 16
func g2r(x: float): float {.inline.} = g2g(x) * Pi / 200

func m2d(x: float): float {.inline.} = m2m(x) * 9 / 160
func m2g(x: float): float {.inline.} = m2m(x) / 16
func m2r(x: float): float {.inline.} = m2m(x) * Pi / 3200

func r2d(x: float): float {.inline.} = r2r(x) * 180 / Pi
func r2g(x: float): float {.inline.} = r2r(x) * 200 / Pi
func r2m(x: float): float {.inline.} = r2r(x) * 3200 / Pi

# Normalizing and converting degrees.
echo "       Degrees        Normalized         Gradians          Mils            Radians"
echo "———————————————————————————————————————————————————————————————————————————————————"
for val in Values:
  echo fmt"{val:15.7f}  {d2d(val):15.7f}  {d2g(val):15.7f}  {d2m(val):15.7f}  {d2r(val):15.7f}"

# Normalizing and converting gradians.
echo ""
echo "      Gradians        Normalized         Degrees           Mils            Radians"
echo "———————————————————————————————————————————————————————————————————————————————————"
for val in Values:
  echo fmt"{val:15.7f}  {g2g(val):15.7f}  {g2d(val):15.7f}  {g2m(val):15.7f}  {g2r(val):15.7f}"

# Normalizing and converting mils.
echo ""
echo "        Mils          Normalized         Degrees         Gradians          Radians"
echo "———————————————————————————————————————————————————————————————————————————————————"
for val in Values:
  echo fmt"{val:15.7f}  {m2m(val):15.7f}  {m2d(val):15.7f}  {m2g(val):15.7f}  {m2r(val):15.7f}"

# Normalizing and converting radians.
echo ""
echo "       Radians        Normalized         Degrees         Gradians          Mils"
echo "———————————————————————————————————————————————————————————————————————————————————"
for val in Values:
  echo fmt"{val:15.7f}  {r2r(val):15.7f}  {r2d(val):15.7f}  {r2g(val):15.7f}  {r2m(val):15.7f}"
