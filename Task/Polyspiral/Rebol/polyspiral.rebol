Rebol [
  title: "Rosetta code: Polyspiral"
  file: %Polyspiral.r3
  url: https://rosettacode.org/wiki/Polyspiral
  needs: 3.10.2
  note: [
    https://github.com/Oldes/Rebol3/releases
    https://github.com/Siskin-framework/Rebol-Blend2D
  ]
]
import blend2d ;; Import Blend2D extension used to draw

incr: 0.0                            ;; Initialize increment variable to 0.0
image: make image! 800x800           ;; Create an 800x800 pixel image canvas
pi2: 2 * PI                          ;; Calculate 2π (full circle in radians), for angle calculations
random/seed 4

;; animation loop (repeats 4 times to create progressive spiral states)
loop 4 [
  x: image/size/x / 2                ;; Set x to center of image (horizontal)
  y: image/size/y / 2                ;; Set y to center of image (vertical)
  length: 5                          ;; Starting length/step for spiral arms
  incr: (incr + 5) % pi2             ;; Increment the angle step (modulo 2π to ensure it wraps correctly)
  angle: incr
  commands: clear []                 ;; Clear previous drawing commands
  color: 100.100.100 + random 155.155.155
  append commands [line-width 1 pen :color line]  ;; Start a new line with width 1 and random pen color

  ;; spiral loop (generates points for the spiral)
  loop 150 [
    x: x + (length * (cos angle))    ;; Move x along the current angle by current length
    y: y + (length * (sin angle))    ;; Move y along the current angle by current length
    append commands as-pair x y      ;; Add the new (x, y) point to the command list
    length: length + 5               ;; Increase the step size for spiral effect
    angle: (angle + incr) % pi2      ;; Progress the angle for the spiral's curvature (modulo 2π)
  ]

  draw image commands                ;; Render the spiral on the image with the accumulated commands
]

try [save %polyspiral.png image]     ;; Save the image as PNG
try [view image]                     ;; Display the final image window with drawn spirals
