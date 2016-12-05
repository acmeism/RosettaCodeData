import rdstdin, strutils, math, strfmt

proc radians(x): float = x * Pi / 180
proc degrees(x): float = x * 180 / Pi

let lat = parseFloat readLineFromStdin "Enter latitude       => "
let lng = parseFloat readLineFromStdin "Enter longitude      => "
let med = parseFloat readLineFromStdin "Enter legal meridian => "
echo ""

let slat = sin radians lat
echo "    sine of latitude:   {:.3f}".fmt(slat)
echo "    diff longitude:     {:.3f}".fmt(lng-med)
echo ""
echo "Hour, sun hour angle, dial hour line angle from 6am to 6pm"

for h in -6..6:
  let hra = float(15 * h) - lng + med
  let hla = degrees arctan(slat * tan radians hra)
  echo "HR={:3d}; HRA={:7.3f}; HLA={:7.3f}".fmt(h, hra, hla)
