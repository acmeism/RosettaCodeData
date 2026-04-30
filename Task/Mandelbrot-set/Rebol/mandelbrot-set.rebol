Rebol [
    title: "Rosetta code: Mandelbrot set"
    file:  %Mandelbrot_set.r3
    url:   https://rosettacode.org/wiki/Mandelbrot_set
    needs: 3.0.0
]

ascii-mandelbrot: function [
    "Integer ASCII Mandelbrot generator"
][
    ;; Define edges and steps
    leftEdge:   -420
    rightEdge:   300
    topEdge:     300
    bottomEdge: -300
    xStep:         7
    yStep:        15
    maxIter:     200

    ;; Prebuild character map for iterations 0–10
    chars: "0123456789@"

    ;; Loop over rows (y0 from topEdge down to bottomEdge)
    for y0 topEdge bottomEdge negate yStep [
        ;; Loop over columns (x0 from leftEdge up to rightEdge)
        for x0 leftEdge rightEdge xStep [
            ;; Initialize iteration state
            x: y: i: 0 theChar: SP
            ;; Iterate until divergence or maxIter
            while [i < maxIter] [
                ;; Compute scaled squares
                x_x: to integer! (x * x / 200)
                y_y: to integer! (y * y / 200)

                ;; Check escape condition
                either x_x + y_y > 800 [
                    ;; Choose character based on iteration count
                    theChar: pick chars either i > 9 [10] [i]
                    ;; Break by setting i to maxIter
                    i: maxIter
                ][
                    ;; Continue Mandelbrot iteration
                    y: to integer! ((x * y) / 100) + y0
                    x: x_x - y_y + x0
                    i: i + 1
                ]
            ]
            ;; Print character for this point
            prin theChar
        ]
        ;; Newline at end of row
        print ""
    ]
]
;; evaluate....
ascii-mandelbrot
