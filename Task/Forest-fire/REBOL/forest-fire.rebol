Rebol [
    title: "Rosetta code: Forest fire"
    file:  %Forest_fire.r3
    url:   https://rosettacode.org/wiki/Forest_fire
    needs: blend2d ;; for draw
]

forest-fire: context [
    ;- public variables
    pfire: 0.0001 ;; probability an empty cell spontaneously ignites
    ptree: 0.01   ;; probability an empty cell grows a new tree
    gs:    100    ;; grid size (number of active cells per row/column)
    ps:    6      ;; point size

    ;- local variables
    rows: cols: gw: gsz: off: f: p: img: none
    draw-cmds: tail [point-size :ps]
    points: #[]

    ;- functions
    init: does [
        rows: cols: gs - 1
        gw:  gs + 2   ;; full row width including 1-cell border on each side
        gsz: gw * gw  ;; total flat block size
        off: gw + 2   ;; index offset: skip border row (gw) + left border (1) + 1-based indexing (1)

        f: make vector! [u8! :gsz] ;; current forest state
        p: copy f                  ;; previous forest state (double buffer)
        img: make image! reduce [ps * gs * 1x1 0.0.0]
        ; initialise ~50% of cells as trees
        for r 0 rows 1 [
            for c 0 cols 1 [
                i: r * gw + c + off
                if 0.5 > random 1.0 [f/:i: 1]
            ]
        ]
    ]

    update-forest: func [/local t i s][
        ;; swap buffers: p = old state, f = new state
        t: append clear #(u8! []) f
           append clear f p
           append clear p t

        for r 0 rows 1 [
            for c 0 cols 1 [
                i: r * gw + c + off
                f/:i: switch/default p/:i [
                    0 [ ;; bare ground: may sprout tree
                       either ptree > random 1.0 [1][0]
                    ]
                    1 [
                        ;; sum all 8 neighbours; burning neighbour has value >= 9
                        s: p/(i - 1 - gw) + p/(i - gw) + p/(i + 1 - gw)
                         + p/(i - 1)                   + p/(i + 1)
                         + p/(i - 1 + gw) + p/(i + gw) + p/(i + 1 + gw)
                        ;; ignite if neighbour burns or lightning
                        either any [s >= 9  pfire > random 1.0] [9][1]
                    ]
                    4 [ 0 ]   ;; nearly-burnt-out cell becomes empty ground
                ][
                    p/:i - 1  ;; burning cell counts down toward extinction
                ]
            ]
        ]
    ]

    redraw-forest: func [/local i h color clr][
        clear draw-cmds
        foreach [k v] points [clear v]
        clr: 0.30.0
        for r 0 rows 1 [
            for c 0 cols 1 [
                i: r * gw + c + off          ;; flat index with border offset
                if p/:i != h: f/:i [         ;; only redraw cells that changed
                    color: switch/default h [
                        0 [0.0.0  ]
                        1 [0.128.0]
                    ][ clr/1: min 255 h * 25 clr]
                    if color [
                        unless blk: points/:color [blk: points/:color: copy []]
                        append blk as-pair c * 6 r * 6  ;; pixel coords (6px per cell)
                    ]
                ]
            ]
        ]

        foreach [clr blk] points [ repend draw-cmds ['fill clr 'point blk] ]
        draw img head draw-cmds
    ]
]

cv: attempt [import opencv] ;; Using OpenCV to display animation (if possible)

with forest-fire [
    init
    either cv [
        print "Press any key to quit."
        forever [
            update-forest
            redraw-forest
            cv/imshow :img               ;; display it
            if 0 < cv/waitKey 5 [break]  ;; for some time
        ]
        cv/destroyAllWindows
    ][
        ;; OpenCV not available!
        ;; update the simulation with a few steps
        loop 100 [ update-forest ]
        redraw-forest
    ]

    unless exists? %Forest_fire.png [ save %Forest_fire.png img ]
]
