Red [Needs: 'View]

random/seed now
board: random [2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0]

; ----------- move engine -----------
tasse: function [b] [
    forall b [while [b/1 = 0] [remove b]]
    head append/dup b 0 4 - length? b
]
somme: function [b] [
    tasse b
    repeat n 3 [
        m: n + 1
        if all [b/:n <> 0 b/:n = b/:m] [
            poke b n b/:n * 2
            poke b m 0
        ]
    ]
    tasse b
]
reshape: function [b d][
    res: copy []
    switch d [
        up    [repeat n 4 [extract/index/into b 4 n res] res]
        down  [repeat n 4 [extract/index/into b 4 n res] reverse res]
        left [res: copy b]
        right  [res: reverse copy b]
    ]
]
mov: function [b d][
    b1: reshape b d
    moved: copy []
    foreach [x y z t] b1 [append moved somme reduce [x y z t]]
    reshape moved d
]

; --------- GUI ---------
colors: [0 gray 2 snow 4 linen 8 brick 16 brown 32 sienna
    64 water 128 teal 256 olive 512 khaki 1024 tanned 2028 wheat]
tsize: 110x110
padsize: 4x4
padlen: 114
mainsize: tsize * 4 + (padsize * 5)
tfont: make font! [size: 30 color: black style: 'bold]

display: does [
    foreach face lay/pane [
        n: face/data
        face/text: either board/:n = 0 [""] [form board/:n]
        face/color: reduce select colors board/:n
    ]
]
lay: layout [
    size mainsize
    title "2048 game"
    backdrop white
    on-key [
        if find [up down left right] d: event/key [
            if board <> newboard: mov board d [
                board: newboard
                if find board 2048 [alert "You win!"]
                until [
                    pos: random 16
                    0 = board/:pos
                ]
                poke board pos either 1 = random 10 [4] [2]
                display
                conds: reduce [not find board 0]
                foreach d [up down left right] [
                    append conds board = mov board d
                ]
                if all conds [alert "You lose!"]
            ]
        ]
    ]
    space padsize
]
repeat n length? board [append lay/pane make face! [
    type: 'base
    offset: padsize + padlen * as-pair (n - 1 % 4) (n - 1 / 4)
    size: tsize
    color: reduce select colors board/:n
    data: n
    font: tfont
]]
display
view lay
