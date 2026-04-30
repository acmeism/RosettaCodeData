Rebol [
    title: "Rosetta code: Box the compass"
    file:  %Box_the_compass.r3
    url:   https://rosettacode.org/wiki/Box_the_compass
    needs: 3.10.0 ;; or something like that
]

form-angle: func[
    "Format the angle as a string with at least one decimal and pad to 2 decimals"
    angle [decimal!]
][
    angle: form round/to angle 0.01
    pad/with find/last angle #"." 3 #"0"  ;; ensure two digits after the decimal point
    append angle #"°"                     ;; add the degree symbol
]

compass: context [
    points: none

    make-points: function [/verbose][
        out: copy []
        ;; Define a character set for the four main directions
        main-dir: charset "NESW"
        ;; 32-wind compass notation (with quarter winds and by-points)
        words: [
            N NbE NNE NEbN NE NEbE ENE EbN E EbS ESE SEbE SE SEbS SSE
            SbE S SbW SSW SWbS SW SWbW WSW WbS W WbN WNW NWbW NW NWbN NNW NbW N
        ]
        ;; Replacement map from shorthand characters to full words (and spacing)
        replacement: #[
            #"N" "north"
            #"b" " by "
            #"S" "south"
            #"E" "east"
            #"W" "west"
        ]
        i: 0  ;; index of the current compass point (0..32)
        foreach word words [
            ;; Compute heading angle:
            ;; Each step is 11.25°, with offsets of +5.62, 0.0, or -5.62 for the 1/3 sub-steps.
            heading: i * 11.25 + (pickz [0.0 5.62 -5.62] i % 3)
            ;; Start with the symbolic label (e.g., "NEbE") as a mutable string
            text: to string! word
            ;; Insert a hyphen after the first main direction if followed by two more main directions
            ;; (e.g., "NEbE" -> "N-EbE")
            parse text [1 main-dir ahead 2 main-dir insert "-"]
            ;; Expand shorthand letters to full words using the replacement table:
            ;; - Replace N/S/E/W with north/south/east/west
            ;; - Replace 'b' with " by "
            parse text [any [p: change skip (any [replacement/(p/1) p/1])]]
            ;; Capitalize first letter of the expanded label (e.g., "north by east" -> "North by east")
            uppercase/part text 1
            if verbose [
                ;; Print three columns:
                ;; - Ordinal index within 32-wind cycle (1..32)
                ;; - Formatted angle
                ;; - Expanded textual compass point
                print [
                    pad (i % 32 + 1) -3
                    pad form-angle heading -7
                    pad form word 5
                    text
                ]
            ]
            repend out [heading word text]
            ++ i
        ]
        new-line/skip out true 3
        out
    ]

    nearest-text: function [
        "Returns the nearest compass point text for a given angle."
        angle     [number! integer! decimal!]
    ][
        ;; :lazily build the points table if not already built
        unless points [points: make-points]
        ;; Normalize query angle into [0,360)
        angle: angle % 360.0
        if angle < 0 [angle: angle + 360.0]

        best-diff: 1e9
        ;; Walk triples: angle word text
        foreach [deg wrd txt] points [
            ;; Compute minimal circular difference
            diff: abs deg - angle
            if diff < best-diff [
                best-diff: diff
                best: txt ;; remember the text for the closest heading
            ]
        ]
        best
    ]
]

;; Print all angle texts
compass/make-points/verbose

print "^/Resolve texts for random angles:"
random/seed 1
loop 5 [
    angle: random 360.0
    print [
        pad form-angle angle -7
        compass/nearest-text angle
    ]
]
