Rebol [
    title: "Rosetta code: Fractal tree"
    file:  %Fractal_tree.r3
    url:   https://rosettacode.org/wiki/Fractal_tree
    needs: 3.16.0
]

b2d: import 'blend2d          ;--use blend2d (draw module)
cv:  attempt [import 'opencv] ;--for visualisation

fractal-tree: function/with [
    spec [block! map! object!] "Configuration options"
][
    scaleFactor: any [select spec 'scaleFactor 0.6     ] ;; Branch length scaling factor (default 0.6)
    forkAngle:   any [select spec 'forkAngle   0.1 * pi] ;; Branching angle in radians (default 0.1·π)
    baseLen:     any [select spec 'baseLen     10.0    ] ;; Base branch length (default 10.0)
    size:        any [select spec 'size        600x600 ] ;; Image dimensions (default 600×600)
    depth:       any [select spec 'depth       9       ] ;; Recursion depth (default 9)
    start-angle: any [select spec 'angle       1.5 * pi] ;; Start angle pointing upward
    ;; Create a blank image of given size
    img: make image! size
    start-point: as-pair size/x / 2 size/y ;; center bottom of image
    draw-tree :start-point :start-angle :depth
    ;; Return the generated image
    img
][
    ;; fractal-tree function context -----------------
    img:         ;; Image to draw into (closed over)
    scaleFactor: ;; Branch scaling factor (closed over)
    forkAngle:   ;; Branching angle (closed over)
    baseLen:     ;; Base branch length (closed over)
    size: none   ;; Image size (closed over)

    draw-tree: function [
        pos     [pair!]     ;; Current position as pair! (x y)
        angle   [decimal!]  ;; Current branch angle (radians)
        depth   [integer!]  ;; Remaining recursion depth
    ][
        ;; Calculate end point of current branch
        len: depth * baseLen
        pos2: as-pair
            pos/x + (len * cos angle)
            pos/y + (len * sin angle)
        ;; Draw branch line with width proportional to depth
        draw img compose [
            line-width (depth) pen red line (pos) (pos2)
        ]
        ;; Recurse for right and left sub-branches
        -- depth
        if depth > 0 [
            draw-tree pos2 angle + forkAngle depth
            draw-tree pos2 angle - forkAngle depth
        ]
    ]
]

;; Usage example:
img: fractal-tree [size: 800x600 depth: 10]
save %fractal-tree.png img
if cv [
    cv/imshow/name :img "Fractal Tree"
    cv/waitKey 0
]
