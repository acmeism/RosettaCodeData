import os, osproc, strformat, strscans

# Retrieve video modes.
let p = startProcess("xrandr", "", ["-q"], nil, {poUsePath})
var currWidth, currHeight = 0   # Current video mode.
var width, height = 0           # Some other video mode.
for line in p.lines:
  echo line
  # Find current display mode, marked by an asterisk.
  var f: float
  if currWidth == 0:
    # Find current width and height.
    discard line.scanf(" $s$ix$i $s$f*", currWidth, currHeight, f)
  elif width == 0:
    # Find another width and height.
    discard line.scanf(" $s$ix$i $s$f", width, height, f)
p.close()

# Change video mode.
let newMode = &"{width}x{height}"
sleep 1000
echo "\nSwitching to ", newMode
sleep 2000
discard execProcess("xrandr", "", ["-s", newMode], nil, {poUsePath})

# Restore previous video mode.
let prevMode = &"{currWidth}x{currHeight}"
sleep 1000
echo "\nSwitching back to ", prevMode
sleep 2000
discard execProcess("xrandr", "", ["-s", prevMode], nil, {poUsePath})
