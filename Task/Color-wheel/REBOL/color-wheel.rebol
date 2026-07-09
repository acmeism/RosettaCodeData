Rebol [
    title: "Rosetta code: Color wheel"
    file:  %Color_wheel.r3
    url:   https://rosettacode.org/wiki/Color_wheel
]

color-wheel: function [
    "Generates a circular HSV color wheel image of given width"
    width [integer!]
][
    img: make image! as-pair width width
    radius: width / 2.0
    clr: 0.0.0 v: 255                                ;; reusable RGB tuple; v=full brightness
    repeat y width [
        repeat x width [
            rx: x - radius                                    ;; offset from center
            ry: y - radius
            s: (sqrt (rx * rx) + (ry * ry)) / radius          ;; distance from center (0..1)
            if s <= 1.0 [                                     ;; skip corners outside circle
                h: (180 + (arctangent2 as-pair rx ry)) / 60   ;; hue in 0..6 sectors
                i: to integer! h                              ;; sector index
                f: h - i                                      ;; fractional part within sector
                q: 255 * (1.0 - (f * s))
                p: 255 * (1.0 - s)
                t: 255 * (1.0 - ((1.0 - f) * s))
                switch i % 6 [
                    0 [clr/1: v  clr/2: t  clr/3: p]
                    1 [clr/1: q  clr/2: v  clr/3: p]
                    2 [clr/1: p  clr/2: v  clr/3: t]
                    3 [clr/1: p  clr/2: q  clr/3: v]
                    4 [clr/1: t  clr/2: p  clr/3: v]
                    5 [clr/1: v  clr/2: p  clr/3: q]
                ]
                img/((y - 1) * width + x): clr
            ]
        ]
    ]
    img
]

browse save %Color_wheel.png color-wheel 400
