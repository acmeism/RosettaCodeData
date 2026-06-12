Rebol [
    title: "Rosetta code: Boids"
    file:  %Boids.r3
    url:   https://rosettacode.org/wiki/Boids
    note:  "Translated from Red"
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
vmag:   func [v][sqrt ((v/x * v/x) + (v/y * v/y))]
vnorm:  func [v /local m][ m: vmag v  either m > 0 [v * 1.0 / m][0x0] ]
vlimit: func [v m][ either m < vmag v [m * vnorm v][v] ]
vdist:  func [a b][vmag a - b]
vdot:   func [a b][(a/x * b/x) + (a/y * b/y)]

;=============================
; BOIDS
;=============================
boids: collect [
    repeat i N [
        keep make map! compose [
            pos: (as-pair random 50 random H) ; started at left side
            vel: (as-pair
                random 1.0         ; heading to the right side
                (1.0 - random 2.0) ; with some vertical variations
            )
        ]
    ]
]

;== OBSTACLES DATA ===
obstacles: [
   #[c: 160x20  r: 80]
   #[c: 445x89  r: 30]
   #[c: 700x140 r: 90]
]

;== SIMPLE OBSTACLE AVOIDANCE LOGIC ==
obstacle-avoidance: function [b][
    force: 0x0
    dir: vnorm b/vel
    ahead: b/pos + (dir * (max-speed * 10))
    foreach o obstacles [
        d: vdist ahead o/c
        if d < (o/r + 6.0) [
            side: as-pair (negate dir/y) dir/x
            to-c: o/c - b/pos
            if ((to-c/x * side/x) + (to-c/y * side/y)) > 0 [
                side: side * -1.0
            ]
            force: force + side
        ]
    ]
    if zero? vmag force [return 0x0]
    1.8 * vnorm force   ; instead of 2.5
]

resolve-obstacle-collision: function [b o][
    dvec: b/pos - o/c
    d: vmag dvec

    if d < o/r [
        ; 1) push boid to surface
        n: vnorm dvec
        b/pos: o/c + (n * o/r)

        ; 2) remove inward velocity
        vn: vdot b/vel n
        if vn < 0.0 [
            b/vel: b/vel - (n * vn)
        ]
    ]
]

;=============================
; UPDATE LOGIC
;=============================
flow: 0.05x0 ; right bias

update-boids: function [][
    foreach b boids [
        sep: ali: coh: 0x0
        count: 0
        foreach o boids [
            if o <> b [
                d: vdist b/pos o/pos
                if d < neighbor-radius [
                    ali: ali + o/vel
                    coh: coh + o/pos
                    ++ count
                ]
                if d < separation-radius [
                    sep: sep + b/pos - o/pos
                ]
            ]
        ]
        if count > 0 [
            nc: 1.0 / count
            ali: ali-weight * (vnorm ali * nc)
            coh: coh-weight * (vnorm (coh * nc) - b/pos)
            sep: sep-weight * (vnorm sep)
        ]
        avoid: obstacle-avoidance b
        acc: (((sep + ali) + coh) + avoid) + flow
        b/vel: vlimit b/vel + acc max-speed
    ]

    ;== EDGE MECHANISM ==
    foreach b boids [
        b/pos: b/pos + b/vel

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
;; Prepare constant draw commands for the background.
background: [fill-all black fill-pen brown]
foreach o obstacles [
    append background compose [circle (o/c) (o/r)]
]
;; Set the color for drawing boids.
append background [pen red]

draw-frame: function [][
    blk: clear []
    ;== Prepare Background with obstacles
    append blk background
    ;== Prepare Boids
    update-boids
    foreach b boids [
        ;; Using 3x append to avoid temporary block construction.
        append append append blk
            'line
            b/pos
            b/pos + b/vel
    ]
    ;== Draw the image.
    draw img blk
]

;=============================
; START
;=============================
import blend2d
img: make image! as-pair W H
either function? :view [
    ;; Show animation when VIEW is available.
    gob: make gob! [image: img]
    win: view/no-wait gob
    visible?: true
    ;; Register an event handler to detect closing the window.
    handle-events [
        name: 'view-boids
        priority: 100
        handler: func [event] [
            if switch event/type [
                close [true]
                key [event/key = escape]
            ][
                unhandle-events self
                unview event/window
                visible?: false
            ]
            none
        ]
    ]
    while [visible?][
        draw-frame
        show win
        wait 0.01
    ]
][
    ;; Or simulate some number of frames...
    loop 100 [draw-frame]
    ;; ...and save the image.
    save %out.png img
]
