Rebol [
    title: "Rosetta code: Biorhythms"
    file:  %Biorhythms.r3
    url:   https://rosettacode.org/wiki/Biorhythms
    note: "Based on Red language implementation!"
    needs: 3.10.0 ;; or something like that
]
biorythms: function/with [
    "Calculates biorythmic values for given birthday and target date"
    bday    [date!]
    target  [date!]
][
    days: target - bday
    print [
        "^/Birthday......" bday
        "^/Target date..." target
        "^/Days.........." days "days"
    ]

    foreach [cycle len] cycles [
        posn:       days % len
        quadrant:   to integer! ((posn / len * 4) + 1)
        ampl:       to percent! round/to sin (days / len * 2 * pi) 0.01
        trend:      quadrants/:quadrant
        desc: case [
            ampl >  0.95          [" Peak"]
            ampl < -0.95          [" Valley"]
            0.05 >= absolute ampl [" Critical transition"]
            true [
                t: to integer! (quadrant / 4 * len) - posn
                ajoin [pad ampl -4 SP trend/1 ", next" trend/2 " in " t " days)"]
            ]
        ]
        print [cycle pad reduce [posn "of" len] -8 ":" desc]
    ]
][
    cycles: [
        "Physical day  " 23
        "Emotional day " 28
        "Mental day    " 33
    ]

    quadrants: [
        ["(up and rising"    "peak"      ]
        ["(up but falling"   "transition"]
        ["(down and falling" "valley"    ]
        ["(down but rising"  "transition"]
    ]
]

biorythms   1943-03-09  1972-07-11 ; Bobby Fisher won the World Chess Championship
biorythms   1987-05-22  2023-01-29 ; Novak Đoković won the Australian Open for the 11th time
biorythms   1969-01-03  2013-09-13 ; Michael Schuhmacher's bad skiing accident
