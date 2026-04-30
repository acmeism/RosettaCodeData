Rebol [
    title: "Rosetta code: Dragon curve"
    file:  %Dragon_curve.r3
    url:   https://rosettacode.org/wiki/Dragon_curve
    needs: 3.0.0
]

bit-count: function [n [integer!]] [
    count: 0
    while [n > 0] [
        count: count + (n & 1)  ;; add lowest bit
        n: n >> 1               ;; logical right-shift by 1
    ]
    count
]

dragon-curve: function [steps [integer!]][
    ;; Initialize state
    x: y: minx: maxx: miny: maxy: 0
    data: make map! []

    ;; Loop for each step
    for i 0 steps 1 [
        ;; Convert iteration number to direction using Gray code modulo 4
        dir: (bit-count (i xor (i >> 1))) % 4

        ;; Compute next coordinates
        nx: x + pickz [1 0 -1 0] dir
        ny: y + pickz [0 1 0 -1] dir

        ;; Determine outbound/inbound bits
        set [ob: ib:] pickz [[8 4] [2 1] [4 8] [1 2]] dir

        ;; Update cell at current position
        key-cur: as-pair y x
        data/:key-cur: ob or any [data/:key-cur 0]

        ;; Update cell at next position
        key-nxt: as-pair ny nx
        data/:key-nxt: ib or any [data/:key-nxt 0]

        ;; Update bounding box
        minx: min minx nx
        maxx: max maxx nx
        miny: min miny ny
        maxy: max maxy ny

        ;; Advance position
        x: nx
        y: ny
    ]

    ;; Draw the result
    chars: " ╵╷│╴┘┐┤╶└┌├─┴┬┼"
    for y miny maxy 1 [
        line: clear ""
        for x minx maxx 1 [
            key: as-pair y x
            val: 1 + any [data/:key 0]
            append line chars/:val
        ]
        print line
    ]
]

;; Draw result:
dragon-curve 511
