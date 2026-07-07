Rebol [
    title: "Rosetta code: Brownian tree"
    file:  %Brownian_tree.r3
    url:   https://rosettacode.org/wiki/Brownian_tree
]

brownian-tree: function [
    "Generates a Brownian tree DLA image using growing bounding box"
    size [pair!]
    /with
     margin [integer!] "spawn margin around seed/attachment; default 100"
     seeds  [integer!] "number of additional colored points; default 0"
][
    w: to integer! size/x
    h: to integer! size/y
    center: size / 2
    margin: any [margin 100]

    ;; bounding box: particles spawn and walk within this region
    TL: max 1x1  center - margin
    BR: min size center + margin
    L: TL/x  R: BR/x
    T: TL/y  B: BR/y
    bb-size: BR - TL

    ;; start with black image
    img: make image! reduce [size 0.0.0]
    ;; place seed and random colored starting points
    img/:center: 255.255.255
    loop any [seeds 0] [
        img/(TL + random bb-size): 50.50.50 + random 200.200.200
    ]

    loop w * h / 1.5 [
        ;; spawn particle at random position inside bounding box
        p: TL + random bb-size
        unless zero? first img/:p [continue]
        clr: none
        ;; random walk until particle hits a neighbor or escapes the box
        until [
            p: p + -2x-2 + random 3x3
            any [
                ;; bounding box edge detection
                p/x <= L  p/x >= R  p/y <= T  p/y >= B
                ;; color of first occupied cardinal neighbor
                not zero? first clr: (img/(p - 0x1))
                not zero? first clr: (img/(p - 1x0))
                not zero? first clr: (img/(p + 1x0))
                not zero? first clr: (img/(p + 0x1))
            ]
        ]

        if clr [
            ;; attach particle
            img/:p: clr
            ;; expand bounding box toward new attachment point
            TL: max 1x1  p - margin
            BR: min size p + margin
            L: TL/x  R: BR/x
            T: TL/y  B: BR/y
            bb-size: BR - TL
        ]
    ]
    img
]

random/seed 1
;; using just one seed:
img: brownian-tree 200x200
browse save %Brownian_tree_v1.png resize/filter img 800x800 'box
;; using multiple colored seeds:
img: brownian-tree/with 200x200 50 20
browse save %Brownian_tree_v2.png resize/filter img 800x800 'box

