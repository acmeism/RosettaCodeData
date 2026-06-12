Red [
    Title: "Harriss Spiral - Turtle Graphics Style"
   Author: "hinjolicious"
   Resources: "Red Sensei, P5js code by Quark"
   Note: "Implemented using turtle graphics methods"
    Needs: View
]

;-- Constants
wnd-w: 1000
wnd-h: 800
cx: 520
cy: 650

hsr: 1.3247179  ; Harriss spiral ratio
limit: 9

;-- Turtle state
turtle-x: 0.0
turtle-y: 0.0
turtle-angle: 0.0  ; degrees, 0 = right, 90 = down

;-- Stack for push/pop
turtle-stack: []

;-- Drawing commands
draw-cmds: compose [
   pen off fill-pen off line-width 1]

;-- Turtle functions
turtle-init: func [x y angle] [
    turtle-x: x
    turtle-y: y
    turtle-angle: angle
]

push-turtle: does [
    append/only turtle-stack reduce [turtle-x turtle-y turtle-angle]
]

pop-turtle: does [
    either empty? turtle-stack [
        print "Stack underflow!"
    ][
        set [turtle-x turtle-y turtle-angle] last turtle-stack
        take/last turtle-stack
    ]
]

turn-left:  func [deg] [turtle-angle: turtle-angle - deg]
turn-right: func [deg] [turtle-angle: turtle-angle + deg]

pen-down: true  ;-- Add this to your global state

;-- Pen control
pen-up: does [pen-down: false]
pen-dn: does [pen-down: true]

;-- Move forward with pen control
turtle-forward: func [distance /local new-x new-y] [
    new-x: turtle-x + (distance * cosine turtle-angle)
    new-y: turtle-y + (distance * sine turtle-angle)

    if pen-down [
        append draw-cmds compose [
            pen red
            line-width 1
            line (as-pair to-integer turtle-x to-integer turtle-y)
                 (as-pair to-integer new-x to-integer new-y)
        ]
    ]

    turtle-x: new-x
    turtle-y: new-y
]

;-- Move backward
turtle-backward: func [distance] [
    turtle-forward negate distance
]

;-- Draw arc from current position
;-- dir: 1 = left (counter-clockwise), -1 = right (clockwise)
draw-arc: func [radius sweep-deg dir /local center-x center-y start-ang end-ang r color ps] [
   dir: negate dir ;tweak!

    ;-- Calculate center of arc (perpendicular to turtle heading)
    ;-- In screen coords (Y-down): left is +90, right is -90 from heading
    either dir = 1 [
        ;-- Left turn: center is to the left
        center-x: turtle-x + (radius * cosine (turtle-angle + 90))
        center-y: turtle-y + (radius * sine (turtle-angle + 90))
    ][
        ;-- Right turn: center is to the right
        center-x: turtle-x + (radius * cosine (turtle-angle - 90))
        center-y: turtle-y + (radius * sine (turtle-angle - 90))
    ]

    start-ang: arctangent2 (turtle-y - center-y) (turtle-x - center-x)

    ;-- Sweep direction: left turn = negative sweep in screen coords
    either dir = 1 [
        end-ang: start-ang + sweep-deg  ; clockwise in screen = left turn visually
    ][
        end-ang: start-ang - sweep-deg
    ]

    ;-- Color based on radius (matching p5.js formula)
   ;first arc intentionally made dark (not visible)
    r: radius
    color: as-color
        min 255 max 0 to-integer (3 * (100 - r))
        min 255 max 0 to-integer (250 - r)
        min 255 max 0 to-integer (128 - (r / 2))

    ps: max 1 to-integer (radius / 10)

    append draw-cmds compose [
        pen (color)
        line-width (to-integer ps)
        arc (as-pair to-integer center-x to-integer center-y)
            (as-pair to-integer radius to-integer radius)
            (to-integer start-ang) (to-integer (sweep-deg * dir))
    ]

    ;-- Update turtle position
    turtle-x: center-x + (radius * cosine end-ang)
    turtle-y: center-y + (radius * sine end-ang)

    ;-- Update heading: after a left turn, heading increases in screen coords
    turtle-angle: turtle-angle + (sweep-deg * dir)
]

;-- Core recursive function
to-curve: func [len dir] [
    draw-arc (len * (square-root 2) / 2) 90 dir
    turn-left 180
]

to-harriss: func [len lim dir] [
    if len > lim [
        to-curve len dir
        push-turtle
        to-harriss (len / 1.8) lim 1      ; LT = 1
        pop-turtle
        turn-left 180
        to-harriss (len / hsr) lim 1
        turn-right 90
    ]
]

;-- Initialize turtle: start at (50, 180), facing 315 degrees
turtle-init (570) (750) (315.0)

;-- Generate the spiral
to-harriss 400 limit 1

;-- Display
view/tight [
    title "Harriss Spiral"
    base with [size: as-pair wnd-w wnd-h] black draw draw-cmds
]
