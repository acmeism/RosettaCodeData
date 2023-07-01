function interpret(text::String)
    ip, accum, isready, ram = 0x1, 0x0, true, zeros(UInt8, 32)
    NOP() = (ip = mod1(ip + 1, 32))
    LDA() = (accum = ram[ram[ip] & 0b00011111 + 1]; ip = mod1(ip + 1, 32))
    STA() = (ram[ram[ip] & 0b00011111 + 1] = accum; ip = mod1(ip + 1, 32))
    ADD() = (accum += ram[ram[ip] & 0b00011111 + 1]; ip = mod1(ip + 1, 32))
    SUB() = (accum -= ram[ram[ip] & 0b00011111 + 1]; ip = mod1(ip + 1, 32))
    BRZ() = (ip = (accum == 0) ? ram[ip] & 0b00011111 + 1 : mod1(ip + 1, 32))
    JMP() = (ip = ram[ip] & 0b00011111 + 1)
    STP() = (println("Program completed with accumulator value $(accum).\n"); isready = false)
    step = [NOP, LDA, STA, ADD, SUB, BRZ, JMP, STP]
    assemblywords = Dict(s => i - 1 for (i, s) in pairs(string.(step)))
    labels = Dict{String, Int}()
    arglabels = Dict{Int, Tuple{Int, String}}()
    for (i, line) in pairs(strip.(split(text, "\n")))
        i > 32 && break
        line = replace(line, r";.*$" => "")  # remove comment
        if occursin(":", line)
            label, line = split(line, ":", limit = 2)
            haskey(labels, label) && error("Duplicate label at line $i")
            labels[strip(label)] = i - 1
        end
        if isempty(line)
           ram[i] = 0
        elseif (m = match(r"(\w\w\w)\s+([a-zA-Z]\w*)", line)) != nothing
            arglabels[i] = (UInt8((assemblywords[m.captures[1]] << 5)), m.captures[2])
        elseif (m = match(r"(\w\w\w)\s+(\d\d*)", line)) != nothing
            ram[i] = UInt8((assemblywords[m.captures[1]] << 5) | parse(UInt8, m.captures[2]))
        elseif (m = match(r"([a-zA-Z]\w*)", line)) != nothing
            ram[i] = UInt8(assemblywords[m.match] << 5)
        elseif (m = match(r"\d\d*", line)) != nothing
                ram[i] = parse(UInt8, m.match)
        else
            error("Compilation error at line $i: error parsing <$line>")
        end
    end
    for (i, t) in arglabels
        ram[i] = t[1] | labels[t[2]]
    end
    while isready
        step[ram[ip] >> 5 + 1]()
    end
    return accum
end

const testprograms = [
    """
        LDA 3
        ADD 4
        STP
        2
        2
    """,
    """
        LDA 12
        ADD 10
        STA 12
        LDA 11
        SUB 13
        STA 11
        BRZ 8
        JMP 0
        LDA 12
        STP
        8
        7
        0
        1
    """,
    """
        LDA 14
        STA 15
        ADD 13
        STA 14
        LDA 15
        STA 13
        LDA 16
        SUB 17
        BRZ 11
        STA 16
        JMP 0
        LDA 14
        STP
        1
        1
        0
        8
        1
    """,
    """
        LDA 13
        ADD 15
        STA 5
        ADD 16
        STA 7
        NOP
        STA 14
        NOP
        BRZ 11
        STA 15
        JMP 0
        LDA 14
        STP
        LDA 0
        0
        28
        1



        6
        0
        2
        26
        5
        20
        3
        30
        1
        22
        4
        24
    """,
    """
        0
        0
        STP
        NOP
        LDA 3
        SUB 29
        BRZ 18
        LDA 3
        STA 29
        BRZ 14
        LDA 1
        ADD 31
        STA 1
        JMP 2
        LDA 0
        ADD 31
        STA 0
        JMP 2
        LDA 3
        STA 29
        LDA 0
        ADD 30
        ADD 3
        STA 0
        LDA 1
        ADD 30
        ADD 3
        STA 1
        JMP 2
        0
        1
        3
    """,
    """\
            LDA   x
            ADD   y       ; accumulator = x + y
            STP
    x:            2
    y:            2
    """,
    """\
    loop:   LDA   prodt
            ADD   x
            STA   prodt
            LDA   y
            SUB   one
            STA   y
            BRZ   done
            JMP   loop
    done:   LDA   prodt   ; to display it
            STP
    x:            8
    y:            7
    prodt:        0
    one:          1
    """,
    """\
    loop:   LDA   n
            STA   temp
            ADD   m
            STA   n
            LDA   temp
            STA   m
            LDA   count
            SUB   one
            BRZ   done
            STA   count
            JMP   loop
    done:   LDA   n       ; to display it
            STP
    m:            1
    n:            1
    temp:         0
    count:        8       ; valid range: 1-11
    one:          1
    """,
    """\
    start:  LDA   load
            ADD   car     ; head of list
            STA   ldcar
            ADD   one
            STA   ldcdr   ; next CONS cell
    ldcar:  NOP
            STA   value
    ldcdr:  NOP
            BRZ   done    ; 0 stands for NIL
            STA   car
            JMP   start
    done:   LDA   value   ; CAR of last CONS
            STP
    load:   LDA   0
    value:        0
    car:          28
    one:          1
                        ; order of CONS cells
                        ; in memory
                        ; does not matter
                6
                0       ; 0 stands for NIL
                2       ; (CADR ls)
                26      ; (CDDR ls) -- etc.
                5
                20
                3
                30
                1       ; value of (CAR ls)
                22      ; points to (CDR ls)
                4
                24
    """,
    """\
    p:            0       ; NOP in first round
    c:            0
    start:  STP           ; wait for p's move
    pmove:  NOP
            LDA   pmove
            SUB   cmove
            BRZ   same
            LDA   pmove
            STA   cmove   ; tit for tat
            BRZ   cdeft
            LDA   c       ; p defected, c did not
            ADD   three
            STA   c
            JMP   start
    cdeft:  LDA   p
            ADD   three
            STA   p
            JMP   start
    same:   LDA   pmove
            STA   cmove   ; tit for tat
            LDA   p
            ADD   one
            ADD   pmove
            STA   p
            LDA   c
            ADD   one
            ADD   pmove
            STA   c
            JMP   start
    cmove:        0       ; co-operate initially
    one:          1
    three:        3
    """,
    """\
    LDA  3
    SUB  4
    STP  0
         0
         255
    """,
    """\
    LDA  3
    SUB  4
    STP  0
         0
         1
    """,
    """\
    LDA  3
    ADD  4
    STP  0
         1
         255
    """,
]

for t in testprograms
    interpret(t)
end
