Rebol [
    title: "Rosetta code: Maze generation"
    file:  %Maze_generation.r3
    url:   https://rosettacode.org/wiki/Maze_generation
]

make-maze: function/with [
    width  [integer!]
    height [integer!]
][
    clear visited
    clear walls
    clear exploring

    size: as-pair width height
    append/dup walls 1x1 width * height
    repend exploring [random size - 1x1]

    until [
        expand exploring/1
        empty? exploring
    ]
    reduce [width height copy walls]
][
    size: _ visited: [] walls: [] exploring: []
    offsetof: function [pos] [pos/y * size/x + pos/x + 1]
    visited?: function [pos] [find visited pos]

    newneighbour: function [pos][
        nnbs: collect [
            if all [pos/x > 0            not visited? p: pos - 1x0] [keep p]
            if all [pos/x < (size/x - 1) not visited? p: pos + 1x0] [keep p]
            if all [pos/y > 0            not visited? p: pos - 0x1] [keep p]
            if all [pos/y < (size/y - 1) not visited? p: pos + 0x1] [keep p]
        ]
        pick nnbs random length? nnbs
    ]
    expand: function [pos][
        insert visited pos
        either npos: newneighbour pos [
            insert exploring npos
            do select [
                 0x-1 [o: offsetof npos walls/:o/y: 0]
                 1x0  [o: offsetof  pos walls/:o/x: 0]
                 0x1  [o: offsetof  pos walls/:o/y: 0]
                -1x0  [o: offsetof npos walls/:o/x: 0]
            ] npos - pos
        ][
            remove exploring
        ]
    ]
]

draw-maze: function[spec][
    set [cols: rows: walls:] spec
    out: copy ""
    append/dup out " _" cols
    append out LF
    repeat j rows [
        append out "|"
        repeat i cols [
            p: pick walls (j - 1 * cols + i)
            append out ajoin [pick " _" 1 + p/y pick " |" 1 + p/x]
        ]
        append out LF
    ]
    copy out
]

random/seed now/time
maze: make-maze 15 15
print draw-maze maze
