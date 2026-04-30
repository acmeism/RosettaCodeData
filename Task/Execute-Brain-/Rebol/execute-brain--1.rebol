REBOL [Title: "Brainfuck interpreter"]

tape: make object! [
    pos: 1
    data: [0]
    inc: does [
        data/:pos: data/:pos + 1
    ]
    dec: does [
        data/:pos: data/:pos - 1
    ]
    advance: does [
        pos: pos + 1
        if (length? data) <= pos [
            append data 0
        ]
    ]
    devance: does [
        if pos > 1 [
            pos: pos - 1
        ]
    ]
    get: does [
        data/:pos
    ]
]

brainfuck: make object! [
    data: string!
    code: ""
    init: func [instr] [
        self/data: instr
    ]
    bracket-map: func [text] [
        leftstack: []
        bm: make map! []
        pc: 1
        for i 1 (length? text) 1 [
            c: text/:i
            if not find "+-<>[].," c [
                continue
            ]
            if c == #"[" [
                append leftstack pc
            ]
            if c == #"]" & ((length? leftstack) > 0) [
                left: last leftstack
                take/last leftstack
                append bm reduce [left pc]
                append bm reduce [pc left]
            ]
            append code c
            pc: pc + 1
        ]
            return bm
    ]
    run: function [] [
        pc: 0
        tp: make tape []
        bm: bracket-map self/data
        while [pc <= (length? code)] [
            switch/default code/:pc [
                #"+" [tp/inc]
                #"-" [tp/dec]
                #">" [tp/advance]
                #"<" [tp/devance]
                #"[" [if tp/get == 0 [
                    pc: bm/:pc
                ]]
                #"]" [if tp/get != 0 [
                    pc: bm/:pc
                ]]
                #"." [prin to-string to-char tp/get]
                    ] []
                    pc: pc + 1
                ]
                print newline
    ]
]

bf: make brainfuck []
bf/init input
bf/run
