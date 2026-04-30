Rebol [
    title: "Rosetta code: Pythagoras tree"
    file:  %Pythagoras_tree.r3
    url:   https://rosettacode.org/wiki/Pythagoras_tree
    needs: 3.16.0
]

b2d: import 'blend2d          ;--use blend2d (draw module)
cv:  attempt [import 'opencv] ;--for visualisation

pythagoras-tree: function/with [
    size  [pair!]
    depth [integer!]
][
    img: make image! size
    w: size/x
    h: size/y
    draw-tree w / 2.3 h w / 1.8 h :depth
    ;; Return the generated image
    img
][
    ;; pythagoras-tree function context -----------------
    img:     ;; Image to draw into (closed over)
    f-color: 30.20.10.30  ;; base fill color
    p-color: 10.200.200   ;; base pen color

    draw-tree: function [
        x1 y1 x2 y2
        depth [integer!]
    ][
        f-color/2:  20 + depth * 3
        p-color/1: 255 / depth
        dx: x2 - x1
        dy: y1 - y2
        x3: x2 - dy
        y3: y2 - dx
        x4: x1 - dy
        y4: y1 - dx
        x5: x4 + (0.5 * (dx - dy))
        y5: y4 - (0.5 * (dx + dy))
        draw img reduce [
          'fill-pen f-color
          'pen      p-color
          'line-width 1
          'polygon as-pair x1 y1 as-pair x2 y2 as-pair x3 y3 as-pair x4 y4
          'polygon as-pair x3 y3 as-pair x4 y4 as-pair x5 y5
        ]
        -- depth
        if depth > 0 [
            draw-tree x4 y4 x5 y5 depth
            draw-tree x5 y5 x3 y3 depth
        ]
    ]
]

;; Usage example:
img: pythagoras-tree 1600x800 14
save %pythagoras-tree.jpg img
if cv [
    cv/imshow/name :img "Pythagoras Tree"
    cv/waitKey 0
]
