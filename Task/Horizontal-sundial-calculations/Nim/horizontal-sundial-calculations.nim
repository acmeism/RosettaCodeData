import rdstdin, strutils, math, strformat

let lat = parseFloat readLineFromStdin "Enter latitude       => "
let lng = parseFloat readLineFromStdin "Enter longitude      => "
let med = parseFloat readLineFromStdin "Enter legal meridian => "
echo ""

let slat = sin lat.degToRad
echo &"    sine of latitude:   {slat:.3f}"
echo &"    diff longitude:     {lng-med:.3f}"
echo ""
echo "Hour, sun hour angle, dial hour line angle from 6am to 6pm"

for h in -6..6:
  let hra = float(15 * h) - lng + med
  let hla = arctan(slat * tan(hra.degToRad)).radToDeg
  echo &"HR={h:3d}; HRA={hra:7.3f}; HLA={hla:7.3f}"
