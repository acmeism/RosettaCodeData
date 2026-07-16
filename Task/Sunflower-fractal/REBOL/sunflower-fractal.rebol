Rebol [
    title: "Rosetta code: Sunflower fractal"
    file:  %Sunflower_fractal.r3
    url:   https://rosettacode.org/wiki/Statistics/Sunflower_fractal
    needs: blend2d
]

sunflower-fractal: function [
    "Draw a sunflower spiral on a canvas using Fermat's spiral by default."
    canvas       [image! pair!] "Target image or dimensions to draw on"
    n            [integer!]     "Number of dots"
    s1           [decimal!]     "Dot radius (center radius for Archimedean, fixed for Fermat)"
    /archimedean
    s2           [decimal!]     "Dot radius at the outer edge (Archimedean only)"
][
    ga:     2.39996323                ;; golden angle ≈ 2π(1 - 1/φ) in radians
    size:   either image? canvas [canvas/size][canvas]
    center: size/x / 2                ;; canvas center coordinate
    size:  (size - any [s2 s1]) / 2   ;; usable spiral radius (padded by max dot size)
    blk: copy [fill-all 0.0.0 line-width .5] ;; drawing commands, starting with black background
    clr: 0.0.50                       ;; reusable color tuple (R G 50)
    rad: s1 n: to decimal! n
    repeat i n [
        t: i / n                      ;; progress along spiral: 0.0 (center) to 1.0 (edge)
        r: either archimedean [
            rad: s1 + ((s2 - s1) * t) ;; dot radius grows linearly from s1 to s2
            center * t                ;; Archimedean: radius grows linearly
        ][  center * sqrt t ]         ;; Fermat: sqrt spacing gives uniform dot density
        theta: i * ga                 ;; angle step by golden angle avoids radial banding
        x: center + (r * cos theta)
        y: center + (r * sin theta)
        clr/1: max min (t * 10 * 255) 255 0    ;; red:   bright in inner rings, fades out
        clr/2: max min ((1 - (t / 1.5)) * 255) 255 0  ;; green: fades from center to edge
        repend blk [
            'fill-pen clr
            'circle as-pair x y rad
        ]
    ]
    draw canvas blk
]

browse save %Sunflower_fractal_v1.png sunflower-fractal 800x800 2000 6.0
browse save %Sunflower_fractal_v2.png sunflower-fractal/archimedean 800x800 1500 4.0 10.0
