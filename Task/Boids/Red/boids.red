Red [
    Title: "Boids (Draft Task)"
    Author: "hinjolicious"
    Resources: "ChatGPT :)"
    Purpose: "Implementing boid navigation through obstacles in graphical mode"
    Needs: 'View
]

;=============================
; PARAMETERS
;=============================
W: 860
H: 160
N: 60 ; boids

random/seed now/time/precise ; randomize

; == FLOCKING BEHAVIOR ==
max-speed: 5.0
neighbor-radius: 80.0
separation-radius: 10.0

sep-weight: 1.8
ali-weight: 0.9
coh-weight: 0.15

;=============================
; VECTOR HELPERS (float)
;=============================
vec: func [xx yy][object [x: xx y: yy]]
vadd: func [a b][vec a/x + b/x a/y + b/y]
vsub: func [a b][vec a/x - b/x a/y - b/y]
vmul: func [a k][vec a/x * k a/y * k]
vmag: func [v][sqrt ((v/x * v/x) + (v/y * v/y))]
vnorm: func [v][ m: vmag v  either m > 0.0 [vmul v 1.0 / m][vec 0.0 0.0] ]
vlimit: func [v m][ either (vmag v) > m [vmul (vnorm v) m][v] ]
vdist: func [a b][vmag vsub a b]
vdot: func [a b][(a/x * b/x) + (a/y * b/y)]

;=============================
; BOIDS
;=============================
boids: collect [
    repeat i N [
        keep object [
            pos: vec random 50 random H ; started at left side
            vel: vec
                random 1.0 ; heading to the right side
                (1.0 - random 2.0) ; with some vertical variations
        ]
    ]
]

;== OBSTACLES DATA ===
obstacles: reduce [
  object [c: vec 160 20  r: 80]
  object [c: vec 445 89  r: 30]
  object [c: vec 700 140 r: 90]
]

;== SIMPLE OBSTACLE AVOIDANCE LOGIC ==
obstacle-avoidance: func [b][
    force: vec 0.0 0.0
    dir: vnorm b/vel
    ahead: vadd b/pos (vmul dir (max-speed * 10)) ;30
    foreach o obstacles [
        d: vdist ahead o/c
        if d < (o/r + 6.0) [
            side: vec (negate dir/y) dir/x
            to-c: vsub o/c b/pos
            if ((to-c/x * side/x) + (to-c/y * side/y)) > 0 [
                side: vmul side -1.0
            ]
            force: vadd force side
        ]
    ]
    if (vmag force) = 0.0 [return vec 0.0 0.0]
    vmul (vnorm force) 1.8   ; instead of 2.5
]

resolve-obstacle-collision: function [b o][
    dvec: vsub b/pos o/c
    d: vmag dvec

    if d < o/r [
        ; 1) push boid to surface
        n: vnorm dvec
        b/pos: vadd o/c (vmul n o/r)

        ; 2) remove inward velocity
        vn: vdot b/vel n
        if vn < 0.0 [
            b/vel: vsub b/vel (vmul n vn)
        ]
    ]
]

;=============================
; UPDATE LOGIC
;=============================
flow: vec 0.05 0.0 ; right bias

update-boids: does [
    foreach b boids [
        sep: vec 0.0 0.0  ali: vec 0.0 0.0  coh: vec 0.0 0.0
        count: 0
        foreach o boids [
            if o <> b [
                d: vdist b/pos o/pos
                if d < neighbor-radius [
                    ali: vadd ali o/vel
                    coh: vadd coh o/pos
                    count: count + 1
                ]
                if d < separation-radius [
                    sep: vadd sep vsub b/pos o/pos
                ]
            ]
        ]
        if count > 0 [
            ali: vmul (vnorm vmul ali 1.0 / count) ali-weight
            coh: vmul (vnorm vsub (vmul coh 1.0 / count) b/pos) coh-weight
            sep: vmul (vnorm sep) sep-weight
        ]
        avoid: obstacle-avoidance b
        acc: vadd (vadd (vadd (vadd sep ali) coh) avoid) flow
        b/vel: vlimit vadd b/vel acc max-speed
    ]

    ;== EDGE MECHANISM ==
    foreach b boids [
        b/pos: vadd b/pos b/vel

        ;== AVOID OBSTACLE COLLISION ==
        foreach o obstacles [
          resolve-obstacle-collision b o
        ]

        ;== BOUNDARY CHECK
        if b/pos/x < 0        [b/pos/x: W]
        if b/pos/x > W        [b/pos/x: 0]
        if b/pos/y < 20       [b/vel/y: b/vel/y + 1.9]
        if b/pos/y > (H - 20) [b/vel/y: b/vel/y - 1.9]
    ]
]

;=============================
; DRAWING
;=============================
draw-boids: func [/local blk] [
    blk: copy []
    append blk [
      ;fill-pen white
      pen white
    ]
    foreach b boids [
        append/only blk compose [
            ;circle (as-pair to-integer b/pos/x to-integer b/pos/y) 3
            line (as-pair b/pos/x b/pos/y)
              (as-pair (b/pos/x + b/vel/x) (b/pos/y + b/vel/y))
        ]
    ]
    blk
]

;=============================
; START
;=============================

view/tight compose [
    title "Boids - Rosetta Code"
    base (as-pair (W) (H)) black draw [] rate 60 on-time [
        blk: copy []
        ;== Draw Obstacles ==
        append blk [fill-pen brown circle 160x20 80 circle 445x89 30 circle 700x140 90]
        ;== Draw Boids
        update-boids
        append blk draw-boids
        ;== Draw Animation Frame
        face/draw: blk
    ]
]

