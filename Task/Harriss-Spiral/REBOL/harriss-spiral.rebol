Rebol [
    title: "Rosetta code: Harriss Spiral"
    file:  %Harriss_Spiral.r3
    url:   https://rosettacode.org/wiki/Harriss_Spiral
    needs: Blend2D
]

hariss-spiral: function/with [
    options [block! map!]
][
    turtle-pos:   options/start          ;; starting position (pair!)
    turtle-angle: options/angle          ;; starting heading in degrees
    limit:        any [options/limit 9]  ;; minimum segment length - stops recursion
    start-length: any [options/start-length 400]

    clear turtle-stack
    append clear draw-cmds [
        ;fill 20.20.20 fill-all           ;; dark background
        line-cap 2
        pen off fill off line-width 1
    ]
    to-harriss :start-length :limit 1    ;; kick off recursive drawing
    draw options/size draw-cmds
][
    hsr: 1.3247179                       ;; plastic constant — the Harriss spiral ratio

    ;; Turtle state
    turtle-pos:   0x0                    ;; current position (pair!)
    turtle-angle: 0.0                    ;; current heading (degrees, 0 = right, 90 = down)

    turtle-stack: []                     ;; saved turtle states for push/pop
    draw-cmds:    []                     ;; accumulated Draw dialect commands

    push-turtle: does [
        ;; save pos + heading
        repend turtle-stack [turtle-pos turtle-angle]
    ]
    pop-turtle: does [
        ;; restore last frame
        set [turtle-pos turtle-angle] take/part/last turtle-stack 2
    ]

    turn-left:  func [deg] [turtle-angle: turtle-angle - deg]
    turn-right: func [deg] [turtle-angle: turtle-angle + deg]

    draw-arc: func [
        radius sweep-deg dir             ;; dir: 1 = left turn, -1 = right turn
        /local center start-ang end-ang r b color
    ][
        dir: negate dir                  ;; flip: screen Y-axis is inverted

        center: turtle-pos + either dir = 1 [
            as-pair (radius * cosine (turtle-angle + 90))   ;; center is left of heading
                    (radius * sine   (turtle-angle + 90))
        ][
            as-pair (radius * cosine (turtle-angle - 90))   ;; center is right of heading
                    (radius * sine   (turtle-angle - 90))
        ]

        start-ang: arctangent2 turtle-pos - center          ;; angle from center to turtle

        end-ang: either dir = 1 [
            start-ang + sweep-deg
        ][  start-ang - sweep-deg ]

        ;; brightness by radius: large arcs bright, small arcs dark
        r: min 1.0 max 0.0 (radius - 5) / 395.0   ;; 0 = small, 1 = large
        b: 100 + (r * 155)                        ;; brightness 100–255
        color: to tuple! reduce [b  b * 0.6  b * 0.3]

        append draw-cmds compose [
            pen (color) line-width (radius / 10)
            arc (center) (as-pair radius radius) (start-ang) (sweep-deg * dir)
        ]

        turtle-pos: center + as-pair                    ;; advance turtle to arc's endpoint
            (radius * cosine end-ang)
            (radius * sine   end-ang)

        turtle-angle: turtle-angle + (sweep-deg * dir)  ;; update heading
    ]

    to-curve: func [len dir] [
        draw-arc (len * (square-root 2) / 2) 90 dir     ;; inscribed quarter-circle
        turn-left 180                                   ;; reverse direction for next branch
    ]

    to-harriss: func [len lim dir] [
        if len > lim [                          ;; base case: stop when segment is too small
            to-curve len dir
            push-turtle
            to-harriss (len / 1.8) lim 1        ;; smaller sub-spiral (≈ 1/φ² branch)
            pop-turtle
            turn-left 180
            to-harriss (len / hsr) lim 1        ;; larger sub-spiral (1/plastic-constant branch)
            turn-right 90
        ]
    ]
]

img: hariss-spiral [
    size:  1000x800
    start: 570x750
    angle: 315
    start-length: 400
    limit: 3
]

browse save %Harriss_Spiral.png img
