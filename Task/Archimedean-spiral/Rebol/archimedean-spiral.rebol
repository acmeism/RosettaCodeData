Rebol [
    title: "Rosetta code: Archimedean spiral"
    file: %Archimedean_spiral.r3
    url: https://rosettacode.org/wiki/Archimedean_spiral
    needs: 3.11.0 ; or something like that (Blend2D)
]
;; Import the Blend2D graphics library
import 'blend2d

arc-spiral: function [
    "Draw an Archimedean spiral."
    size [pair!]    "Image dimensions (width x height)"
    ri   [number!]  "Radius increment per step"
    ti   [number!]  "Angle increment per step (in radians)"
][
    p: c: size / 2    ;; Calculate center point of the image
    r: t: 0.0         ;; Initialize radius and angle to zero
    points: clear []  ;; Initialize empty block to store spiral points

    ;; Generate spiral points until radius reaches edge of image
    while [ r < c/x ][
        ;; Store current point
        append points p
        ;; Calculate next point using polar coordinates
        ;; Convert from polar (r, t) to cartesian (x, y)
        p/x: c/x + (r * cos t)
        p/y: c/y + (r * sin t)
        ;; Increment radius (spiral expands outward)
        r: r + ri
        ;; Increment angle (spiral rotates)
        t: t + ti
    ]

    ;; Create new image of specified size
    img: make image! size

    ;; Draw the spiral on the image
    draw img [
        line-width 1     ;; Set line thickness to 1 pixel
        pen 0.0.255      ;; Set pen color to blue (RGB)
        line  :points    ;; Draw connected line through all points
        pen 255.0.0      ;; Set pen color to red (RGB)
        point-size 6     ;; Set point marker size to 6 pixels
        point :points    ;; Draw red dots at each spiral point
    ]
]

img: arc-spiral 800x800 0.05 0.02
save %Archimedean_spiral.png img
view img
