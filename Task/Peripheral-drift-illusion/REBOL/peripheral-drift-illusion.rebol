Rebol [
    title: "Rosetta code: Peripheral drift illusion"
    file:  %Peripheral_drift_illusion.r3
    url:   https://rosettacode.org/wiki/Peripheral_drift_illusion
    needs: blend2d       ;; draw extension
]

n:    15
r:    800 / (3 * n)      ;; base unit: canvas divided into 3n equal parts
offs: 800 / 10 / n       ;; satellite offset distance
step: 360 * 2 / (n - 1)  ;; angle increment between cells

;; translate so first cell centre lands at (1.5r, 1.5r) instead of origin
cmds: compose [pen off translate (as-pair 1.5 * r 1.5 * r)]

repeat row n [
    repeat col n [
        x: (3 * (col - 1)) * r        ;; centre x of current cell
        y: (3 * (row - 1)) * r        ;; centre y of current cell
        angle: (col + row - 2) * step ;; rotation angle per position

        append cmds compose [
            fill-pen white
            circle (as-pair x + (offs * cosine angle)
                            y + (offs * sine   angle)) (r)
            fill-pen black
            circle (as-pair x + (offs * cosine (angle + 180))
                            y + (offs * sine   (angle + 180))) (r)
            fill-pen 44.26.244
            circle (as-pair x y) (r)   ;; blue centre circle
        ]
    ]
]

img: make image! [800x800 141.177.56]  ;; green background
browse save %Peripheral_drift_illusion.png draw img cmds
